#!/bin/bash

# The namespace where MachineSet resources are located
NAMESPACE="openshift-machine-api"

# Loop through each MachineSet in the cluster
for machineset_name in $(oc get machinesets -n ${NAMESPACE} -o jsonpath='{.items[*].metadata.name}'); do
  # Get the current replica count for the MachineSet
  # Default to 0 if the replica count is not set (null)
  current_replicas=$(oc get machineset ${machineset_name} -n ${NAMESPACE} -o jsonpath='{.spec.replicas}' 2>/dev/null || echo 0)
  if [[ "${current_replicas}" == "null" ]]; then
    current_replicas=0
  fi

  # Calculate the desired number of replicas
  new_replicas=$((current_replicas + 1))

  echo "Scaling MachineSet '${machineset_name}' from ${current_replicas} to ${new_replicas} nodes..."

  # Patch the MachineSet with the new replica count
  oc patch machineset ${machineset_name} -n ${NAMESPACE} --type='merge' -p "{\"spec\":{\"replicas\":${new_replicas}}}"
done

echo "All MachineSets have been scaled up by one node."
