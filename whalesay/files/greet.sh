# Greet with the Docker whale on interactive shells (whalesay kit).
case $- in
  *i*) command -v whalesay >/dev/null 2>&1 && whalesay "Happy Whaleness Day" ;;
esac
