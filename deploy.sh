#!/bin/sh
python3 ./SyncObsidian/clear_obs.py
python3 ./SyncObsidian/sync_cyl.py
python3 ./SyncObsidian/sync_research.py
hexo cl
hexo g
hexo d
git add .
git commit -m "$1"
git push origin main
