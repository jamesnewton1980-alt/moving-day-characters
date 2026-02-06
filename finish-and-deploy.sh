#!/bin/bash
# Wait for all pages 31-36 to be generated, then deploy

SRCDIR="/home/rainman/.openclaw/workspace/alex-stokas/books/Moving Day/generated/pages"
REPODIR="/tmp/moving-day-preview"

echo "Waiting for pages 31-36 to complete..."

while true; do
    count=0
    for i in 31 32 33 34 35 36; do
        if [ -f "$SRCDIR/page-$i.png" ]; then
            count=$((count + 1))
        fi
    done
    
    echo "$(date '+%H:%M:%S') - $count/6 remaining pages complete"
    
    if [ $count -eq 6 ]; then
        echo "All pages complete!"
        break
    fi
    
    sleep 30
done

# Copy remaining pages
echo "Copying final pages..."
for i in 31 32 33 34 35 36; do
    cp "$SRCDIR/page-$i.png" "$REPODIR/pages/"
    echo "Copied page-$i.png"
done

# Verify all 36 pages + page-01-final
echo ""
echo "=== FINAL FILE COUNT ==="
ls "$REPODIR/pages/" | wc -l
ls "$REPODIR/pages/" | sort

# Push to GitHub
cd "$REPODIR"
git add -A
git commit -m "Moving Day - Complete illustration preview (36 pages)"
git branch -M main
git push -u origin main --force

echo ""
echo "=== DEPLOY COMPLETE ==="
echo "Repo pushed. Now enable GitHub Pages..."
