#!/usr/bin/env sh

suffix="$(hexdump -n 3 -e '1/2 "%04x"' /dev/urandom)"

kubectl apply -f - << EOT
apiVersion: batch/v1
kind: Job
metadata:
  namespace: ${NAMESPACE}
  name: obelix-sync-${NODE}
spec:
  template:
    spec:
      nodeName: ${NODE}
      restartPolicy: Never
      hostNetwork: true
      dnsPolicy: ClusterFirstWithHostNet
      serviceAccountName: obelix
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
