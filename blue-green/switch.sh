#!/bin/bash
# Blue-Green traffic switch
# Usage: ./switch.sh blue|green   (no arg = show current live environment)
set -e

TARGET="$1"
CURRENT=$(kubectl get svc nodejs-bg-service -o jsonpath='{.spec.selector.version}')

if [ -z "$TARGET" ]; then
  echo "Currently LIVE: $CURRENT"
  exit 0
fi

if [ "$TARGET" != "blue" ] && [ "$TARGET" != "green" ]; then
  echo "Usage: ./switch.sh blue|green"
  exit 1
fi

if [ "$TARGET" = "$CURRENT" ]; then
  echo "$TARGET is already live."
  exit 0
fi

echo "Switching traffic: $CURRENT -> $TARGET ..."
kubectl patch svc nodejs-bg-service -p "{\"spec\":{\"selector\":{\"app\":\"nodejs-app\",\"version\":\"$TARGET\"}}}"

echo "Done. ALL traffic now goes to $TARGET."
echo "Rollback anytime with: ./switch.sh $CURRENT"
