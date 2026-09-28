#!/bin/bash
set -e

echo "=== Setting up Scenario 01: Recover MariaDB Using an Existing PV ==="

kubectl create ns mariadb --dry-run=client -o yaml | kubectl apply -f -

# Clean any prior state
kubectl delete deployment mariadb -n mariadb --ignore-not-found >/dev/null 2>&1 || true
kubectl delete pvc mariadb -n mariadb --ignore-not-found >/dev/null 2>&1 || true
kubectl delete pv mariadb-pv --ignore-not-found >/dev/null 2>&1 || true

echo "Creating retained PersistentVolume 'mariadb-pv'..."
kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mariadb-pv
  labels:
    app: mariadb
spec:
  capacity:
    storage: 250Mi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: standard
  hostPath:
    path: /mnt/data/mariadb
EOF

# Write skeleton deployment manifest with blank claimName for the student to fill in
cat <<'EOF' > "${HOME}/mariadb-deploy.yaml"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mariadb
  namespace: mariadb
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mariadb
  template:
    metadata:
      labels:
        app: mariadb
    spec:
      containers:
      - name: mariadb
        image: mariadb:10.6
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: rootpass
        volumeMounts:
        - name: mariadb-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: mariadb-storage
        persistentVolumeClaim:
          claimName: ""
EOF

echo ""
echo "=== Setup complete ==="
echo "  - Namespace: mariadb"
echo "  - PV 'mariadb-pv' exists (Retain, 250Mi, storageClassName=standard)"
echo "  - Skeleton manifest: ~/mariadb-deploy.yaml (claimName is empty)"
echo ""
echo "See TASK.md for full instructions."
