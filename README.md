## INSTALL HTPASSWORD
```oc patch oauth/cluster --type=json -p='[{"op": "add", "path": "/spec/identityProviders/-", "value": {"name": "htpasswd", "mappingMethod": "claim", "type": "HTPasswd", "htpasswd": {"fileData": {"name": "htpass-my-secret"}}}}]'```

## CREATE SECRET
```oc apply -f htpass-my-secret-workshop.yaml```

## WAIT FOR THE OAUTH PODS TO ROLL
```oc get pods -n openshift-authentication -w```

## WE MAY NEED TO INCREASE THE SIZE OF THE CLUSTER
```./scaleup.sh```

## CREATE USER ROLE BINDINGS
```
helm upgrade --install trbl-workshop-users \
  trbl-workshop/users \
  --namespace trbl-workshop \
  --create-namespace \
  --set userCount=20
```

## CREATE THE 'hub' ARGOCD PROJECT
``` oc apply -f trbl-workshop-argo-project.yaml ```

## ADD THE ARGO APPS
``` oc apply -f argo-app-exercises/ -n openshift-gitops ```

## CLEANUP
```
oc delete -f argo-app-exercises/ -n openshift-gitops
oc delete -f trbl-workshop-argo-project.yaml
```

## MANUALLY SYNC THE EXERCISES