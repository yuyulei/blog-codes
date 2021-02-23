kubectl create cm kong-plugin-caoliao-identity --from-file=caoliao-identity -n kong
kubectl create cm kong-plugin-caoliao-prometheus --from-file=caoliao-prometheus -n kong
kubectl create cm kong-plugin-caoliao-terminating --from-file=caoliao-terminating -n kong