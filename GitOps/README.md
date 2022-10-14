# Connecting argocd cli

argoPass=$(oc get secret/argocd-cluster -n openshift-gitops -o jsonpath='{.data.admin\.password}' | base64 -d)

echo $argoPass

argoURL=$(oc get route argocd-server -n openshift-gitops -o jsonpath='{.spec.host}{"\n"}')

echo $argoURL

argocd login --insecure --grpc-web $argoURL  --username admin --password $argoPass
