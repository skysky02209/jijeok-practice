#!/bin/bash
# 지적기능사 실기 연습기 배포: 이 파일을 더블클릭하면 GitHub Pages에 올라갑니다.
cd "$(dirname "$0")"
USER_NAME=skysky02209
REPO=jijeok-practice
URL="https://$USER_NAME.github.io/$REPO/"
echo "== 지적기능사 실기 연습기 배포 =="
[ -d .git ] || git init -q -b main
git add index.html deploy.command
git commit -q -m "배포 $(date '+%Y-%m-%d %H:%M')" || echo "(변경 사항 없음)"
if command -v gh >/dev/null 2>&1; then
  gh repo view "$USER_NAME/$REPO" >/dev/null 2>&1 || gh repo create "$USER_NAME/$REPO" --public --description "지적기능사 실기 연습기"
  git remote get-url origin >/dev/null 2>&1 || git remote add origin "https://github.com/$USER_NAME/$REPO.git"
  git push -u origin main
  gh api -X POST "repos/$USER_NAME/$REPO/pages" -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 || true
else
  if ! git ls-remote "https://github.com/$USER_NAME/$REPO.git" >/dev/null 2>&1; then
    echo "1) 열리는 GitHub 화면에서 저장소 이름 jijeok-practice, Public 으로 [Create repository]를 눌러 주세요."
    open "https://github.com/new?name=$REPO&visibility=public"
    read -r -p "2) 다 만들었으면 엔터를 누르세요..."
  fi
  git remote get-url origin >/dev/null 2>&1 || git remote add origin "https://github.com/$USER_NAME/$REPO.git"
  git push -u origin main
  echo "3) 열리는 Pages 설정에서 Branch를 main / (root) 로 두고 [Save]를 눌러 주세요. (처음 한 번만)"
  open "https://github.com/$USER_NAME/$REPO/settings/pages"
fi
echo ""
echo "배포 주소: $URL  (처음엔 1~2분 뒤에 열립니다)"
open "$URL"
read -n 1 -s -r -p "아무 키나 누르면 창이 닫힙니다"
