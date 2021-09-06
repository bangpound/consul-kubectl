#!/usr/bin/env sh

suffix="$(hexdump -n 3 -e '1/2 "%04x"' /dev/urandom)"

kubectl apply -f - << EOT
apiVersion: batch/v1
kind: Job
metadata:
  namespace: ${NAMESPACE}
  name: obelix-sync-${suffix}
spec:
  template:
    spec:
      nodeName: ${NODE}
      restartPolicy: Never
      hostNetwork: true
      dnsPolicy: ClusterFirstWithHostNet
      serviceAccountName: obelix
      tolerations:
        - key: activecampaign.com/hosted
          operator: Equal
          value: unavailable
          effect: NoExecute
        - key: activecampaign.com/hosted
          operator: Equal
          value: unavailable
          effect: NoSchedule
      containers:
        - name: obelix
          image: ${OBELIX_IMAGE}
          command: ["python", "-m", "obelix", "sync", "--prefix", "deploy/hosted/"]
          volumeMounts:
            - name: products
              mountPath: /products
            - name: deploy
              mountPath: /deploy
      volumes:
        - name: products
          hostPath:
            path: /products
            type: Directory
        - name: deploy
          hostPath:
            path: /deploy
            type: Directory
EOT
