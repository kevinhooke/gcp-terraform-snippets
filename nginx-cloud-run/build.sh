docker build . --platform linux/amd64 -t gcp-nginx-test

docker tag gcp-nginx-test europe-west2-docker.pkg.dev/cloudrun-playground-435514/playground-repo/gcp-nginx-test:2
docker push europe-west2-docker.pkg.dev/cloudrun-playground-435514/playground-repo/gcp-nginx-test:2

#gcloud run deploy gcp-nginx-test --project cloudrun-playground-435514 --image europe-west2-docker.pkg.dev/cloudrun-playground-435514/playground-repo/gcp-nginx-test