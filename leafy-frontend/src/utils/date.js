// 날짜 표시 도우미

// 'YYYY-MM-DD' → 'YYYY.MM.DD'
export function formatDate(value) {
  if (!value) return '';
  const [year, month, day] = String(value).slice(0, 10).split('-');
  return `${year}.${month}.${day}`;
}

// 오늘 기준으로 '오늘', '어제', 'n일 전', 그보다 오래되면 날짜
export function relativeDay(value) {
  if (!value) return '';
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const target = new Date(`${String(value).slice(0, 10)}T00:00:00`);
  const diff = Math.round((today - target) / 86400000);
  if (diff === 0) return '오늘';
  if (diff === 1) return '어제';
  if (diff > 1 && diff < 7) return `${diff}일 전`;
  return formatDate(value);
}

// 브라우저 시간대 기준 오늘 날짜 'YYYY-MM-DD'
export function todayString() {
  const now = new Date();
  const month = String(now.getMonth() + 1).padStart(2, '0');
  const day = String(now.getDate()).padStart(2, '0');
  return `${now.getFullYear()}-${month}-${day}`;
}
