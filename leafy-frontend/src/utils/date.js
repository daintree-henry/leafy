// Date display helpers

// 'YYYY-MM-DD' → 'YYYY.MM.DD'
export function formatDate(value) {
  if (!value) return '';
  const [year, month, day] = String(value).slice(0, 10).split('-');
  return `${year}.${month}.${day}`;
}

// Relative to today: '오늘' (today), '어제' (yesterday), 'n일 전' (n days ago), or the date if older
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

// Today's date in the browser's time zone, as 'YYYY-MM-DD'
export function todayString() {
  const now = new Date();
  const month = String(now.getMonth() + 1).padStart(2, '0');
  const day = String(now.getDate()).padStart(2, '0');
  return `${now.getFullYear()}-${month}-${day}`;
}
