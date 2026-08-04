-- Keep the visible lesson title aligned with the Arabic term used in the explanation.
update public.rules
set title = 'Вопросительная частица «أَ» (هَمْزَةُ الاِسْتِفْهَامِ)'
where id = 382
  and title = 'Вопросительная частица «А» (هَمْزَةُ الاِسْتِفْهَامِ)';
