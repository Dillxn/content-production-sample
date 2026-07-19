#!/usr/bin/env bash
set -euo pipefail

FFMPEG="${FFMPEG:-/tmp/codex-imageio-ffmpeg/imageio_ffmpeg/binaries/ffmpeg-macos-aarch64-v7.1}"
FONT_BOLD="/System/Library/Fonts/Supplemental/Arial Bold.ttf"
FONT_REGULAR="/System/Library/Fonts/Supplemental/Arial.ttf"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/portfolio-videos"
TMP="$OUT/.audio"

mkdir -p "$OUT" "$TMP"

render() {
  local slug="$1"
  local narration="$2"
  local background="$3"
  local accent="$4"
  local scene_one="$5"
  local scene_two_a="$6"
  local scene_two_b="$7"
  local scene_three_a="$8"
  local scene_three_b="$9"
  local scene_four="${10}"
  local audio="$TMP/$slug.aiff"
  local output="$OUT/$slug.mp4"

  say -v Samantha -r 188 -o "$audio" "$narration"

  "$FFMPEG" -hide_banner -loglevel error -y \
    -f lavfi -i "color=c=$background:s=720x1280:r=30:d=18" \
    -i "$audio" \
    -f lavfi -i "sine=frequency=110:sample_rate=44100:duration=18" \
    -filter_complex "[0:v]drawbox=x=0:y=0:w=720:h=22:color=$accent:t=fill,drawbox=x=50:y=118:w=620:h=6:color=$accent:t=fill,drawbox=x=50:y=1120:w='min(620,t/18*620)':h=8:color=$accent:t=fill,drawtext=fontfile='$FONT_REGULAR':text='SELF INITIATED SAMPLE  |  AUTONOMOUS AI ASSISTED':fontcolor=white@0.62:fontsize=18:x=(w-text_w)/2:y=1190,drawtext=fontfile='$FONT_BOLD':text='$scene_one':fontcolor=white:fontsize=56:x=(w-text_w)/2:y=285:enable='between(t,0,4.2)',drawtext=fontfile='$FONT_BOLD':text='$scene_two_a':fontcolor=$accent:fontsize=78:x=(w-text_w)/2:y=330:enable='between(t,4.2,8.2)',drawtext=fontfile='$FONT_REGULAR':text='$scene_two_b':fontcolor=white:fontsize=34:x=(w-text_w)/2:y=465:enable='between(t,4.2,8.2)',drawtext=fontfile='$FONT_BOLD':text='$scene_three_a':fontcolor=white:fontsize=52:x=(w-text_w)/2:y=310:enable='between(t,8.2,13)',drawtext=fontfile='$FONT_REGULAR':text='$scene_three_b':fontcolor=$accent:fontsize=34:x=(w-text_w)/2:y=450:enable='between(t,8.2,13)',drawtext=fontfile='$FONT_BOLD':text='$scene_four':fontcolor=white:fontsize=50:x=(w-text_w)/2:y=355:enable='between(t,13,18)',format=yuv420p[v];[1:a]volume=1.0[voice];[2:a]volume=0.025[bed];[voice][bed]amix=inputs=2:duration=longest[a]" \
    -map "[v]" -map "[a]" -t 18 \
    -c:v libx264 -preset medium -crf 18 -profile:v high \
    -c:a aac -b:a 160k -movflags +faststart "$output"

  echo "$output"
}

render \
  "lead-response-system" \
  "Most leads are not lost because demand disappears. They are lost between an inquiry and a clear next step. Centralize the inbox, reply with one helpful question, and measure response time. The system should protect attention, not replace judgment." \
  "0x0B1220" "0x5DE1FF" \
  "LEADS DO NOT VANISH" \
  "THEY WAIT" "BETWEEN INQUIRY AND NEXT STEP" \
  "ONE INBOX  ONE REPLY" "ONE CLEAR NEXT STEP" \
  "MEASURE RESPONSE TIME"

render \
  "offer-clarity-system" \
  "An offer becomes easier to buy when the promise, proof, and next step fit on one screen. Remove vague language. Show the specific outcome. Then ask for one decision. Clarity is not decoration. It is a conversion tool." \
  "0x14100D" "0xFFB84D" \
  "MAKE OFFERS EASY" \
  "ONE SCREEN" "PROMISE  PROOF  NEXT STEP" \
  "REMOVE THE FOG" "SHOW THE SPECIFIC OUTCOME" \
  "CLARITY CONVERTS"

render \
  "caption-hierarchy-system" \
  "Captions should guide the eye, not compete for it. Keep the sentence readable, emphasize only the decisive words, and time each line to the speaker's meaning. Good caption design disappears while the idea stays." \
  "0x0F1020" "0xB79CFF" \
  "CAPTIONS GUIDE FOCUS" \
  "READABLE" "BEFORE DECORATIVE" \
  "EMPHASIZE LESS" "TIME THE DECISIVE WORDS" \
  "LET THE IDEA STAY"

render \
  "content-repurposing-system" \
  "One useful idea can become a short video, a thumbnail, six posts, and a compact carousel. Start with the core argument. Adapt the framing for each platform. Keep the meaning consistent. Repurposing works when the idea stays intact." \
  "0x071713" "0x61E7A7" \
  "ONE USEFUL IDEA" \
  "TEN ASSETS" "VIDEO  THUMBNAIL  POSTS  CAROUSEL" \
  "ADAPT THE FRAMING" "KEEP THE MEANING" \
  "KEEP THE IDEA INTACT"

render \
  "production-brief-system" \
  "A strong sixty-second production brief answers five things. Who is this for? What should they understand? What proof supports it? What action comes next? And what must never be claimed? Clarity before editing saves revisions after delivery." \
  "0x17100F" "0xFF756B" \
  "BRIEF BEFORE EDITING" \
  "FIVE ANSWERS" "AUDIENCE  IDEA  PROOF  ACTION  LIMITS" \
  "DEFINE THE CLAIM" "DEFINE WHAT MUST NOT BE CLAIMED" \
  "SAVE REVISIONS LATER"

rm -rf "$TMP"
