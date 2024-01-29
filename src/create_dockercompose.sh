#!/bin/sh

repo_list="
adservice
checkoutservice
emailservice
loadgenerator
productcatalogservice
shippingservice
cartservice
currencyservice
frontend
paymentservice
recommendationservice
"

dockercompose_elements="
version
services
"

install_this="my_apps.yaml"

mkdir -p environment

# Structure creation in seperate files
  for element in $dockercompose_elements; do

    mkdir -p $element

    echo "$element:" > $element/0000_default_header.yml

    for repo in $repo_list; do
        case $element in
          "services")
             touch environment/$repo.txt
             echo "  $repo:"			> $element/$repo.yml
             echo "    build: $repo/."		>> $element/$repo.yml
             echo "    container_name: $repo"	>> $element/$repo.yml
             echo "    environment:"		>> $element/$repo.yml
             cat environment/$repo.txt		>> $element/$repo.yml
             echo ""				>> $element/$repo.yml
             ;;

          *)
             touch $element/$repo.yml
             ;;
        esac

    done

  done

volumes_list=$(ls volumes/*.yml | sed 's/\.yml//' | sed 's/volumes\//images_/')

mv $install_this $install_this.old

echo "==== 1 - List version / networks / volumes / services availables in sub-folders ===="
# Définition des lites de fichiers
  services_list=$(ls services/*.yml)

echo "==== 2a - Create $install_this file - add version ===="
# Concaténation des fichiers avec des en-têtes appropriés
echo 'version: "3.5"'   > $install_this

echo "==== 2b - Create $install_this file - add services ===="
echo ""                 >> $install_this
cat $services_list      >> $install_this

