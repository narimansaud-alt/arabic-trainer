-- Restore source-context links in Medina Book 2 lesson 1.
-- Source text rows remain unchanged.
-- UTF-8 payloads are base64 encoded so this migration is transport-safe on Windows.

begin;

do $migration$
declare
  current_content text;
  affected integer;

  course_name_target constant text := convert_from(decode(
    '0JzQtdC00LjQvdGB0LrQuNC5INC60YPRgNGBICjQotC+0LwgMik=',
    'base64'
  ), 'UTF8');

  old_examples_1248 constant text := convert_from(decode(
    'PGRpdiBjbGFzcz0icnVsZS1zdHVkeS1jYXJkIj48c3BhbiBjbGFzcz0icnVsZS1jYXJkLWtp' ||
    'Y2tlciI+0J/RgNC40LzQtdGA0Ysg0YHQtdGB0YLRkdGAINil2ZDZhtmR2Y48L3NwYW4+PGRp' ||
    'diBjbGFzcz0icnVsZS1leGFtcGxlLWxpc3QiPjxkaXYgY2xhc3M9InJ1bGUtZXhhbXBsZS1j' ||
    'YXJkIHJ1bGUtdGVybS1wYXJ0aWNsZSI+PHNwYW4gY2xhc3M9InJ1bGUtZXhhbXBsZS1hciIg' ||
    'ZGlyPSJydGwiIGxhbmc9ImFyIj7Ys9mO2YXZkNi52ZLYqtmPIDxzcGFuIGNsYXNzPSJhci10' ||
    'b25lLXBhcnRpY2xlIj7Yo9mO2YbZkdmOPC9zcGFuPiA8c3BhbiBjbGFzcz0iYXItdG9uZS1u' ||
    'YXNiIj7Yp9mE2ZLZhdmP2K/Zjtix2ZHZkNiz2Y48L3NwYW4+IDxzcGFuIGNsYXNzPSJhci10' ||
    'b25lLXJhZiI+2YXZjtix2ZDZiti22Yw8L3NwYW4+Ljwvc3Bhbj48c3BhbiBjbGFzcz0icnVs' ||
    'ZS1leGFtcGxlLXJ1Ij7QryDRg9GB0LvRi9GI0LDQuywg0YfRgtC+INC/0YDQtdC/0L7QtNCw' ||
    '0LLQsNGC0LXQu9GMINCx0L7Qu9C10L0uPC9zcGFuPjwvZGl2PjxkaXYgY2xhc3M9InJ1bGUt' ||
    'ZXhhbXBsZS1jYXJkIHJ1bGUtdGVybS1wYXJ0aWNsZSI+PHNwYW4gY2xhc3M9InJ1bGUtZXhh' ||
    'bXBsZS1hciIgZGlyPSJydGwiIGxhbmc9ImFyIj7Yp9mE2LPZkdmO2YrZkdmO2KfYsdmO2KnZ' ||
    'jyDZgtmO2K/ZkNmK2YXZjtip2YzYjCA8c3BhbiBjbGFzcz0iYXItdG9uZS1wYXJ0aWNsZSI+' ||
    '2YTZjtmD2ZDZhtmR2Y7Zh9mO2Kc8L3NwYW4+IDxzcGFuIGNsYXNzPSJhci10b25lLXJhZiI+' ||
    '2YLZjtmI2ZDZitmR2Y7YqdmMPC9zcGFuPi48L3NwYW4+PHNwYW4gY2xhc3M9InJ1bGUtZXhh' ||
    'bXBsZS1ydSI+0JzQsNGI0LjQvdCwINGB0YLQsNGA0LDRjywg0L3QviDQvtC90LAg0LrRgNC1' ||
    '0L/QutCw0Y8uPC9zcGFuPjwvZGl2PjxkaXYgY2xhc3M9InJ1bGUtZXhhbXBsZS1jYXJkIHJ1' ||
    'bGUtdGVybS1wYXJ0aWNsZSI+PHNwYW4gY2xhc3M9InJ1bGUtZXhhbXBsZS1hciIgZGlyPSJy' ||
    'dGwiIGxhbmc9ImFyIj48c3BhbiBjbGFzcz0iYXItdG9uZS1wYXJ0aWNsZSI+2YPZjtij2Y7Z' ||
    'htmR2Y48L3NwYW4+IDxzcGFuIGNsYXNzPSJhci10b25lLW5hc2IiPtin2YTZktmF2Y7Ys9mS' ||
    '2KzZkNiv2Y48L3NwYW4+IDxzcGFuIGNsYXNzPSJhci10b25lLXJhZiI+2YXZjtiv2ZLYsdmO' ||
    '2LPZjtip2Yw8L3NwYW4+Ljwvc3Bhbj48c3BhbiBjbGFzcz0icnVsZS1leGFtcGxlLXJ1Ij7Q' ||
    'nNC10YfQtdGC0Ywg0YHQu9C+0LLQvdC+INGI0LrQvtC70LAuPC9zcGFuPjwvZGl2PjxkaXYg' ||
    'Y2xhc3M9InJ1bGUtZXhhbXBsZS1jYXJkIHJ1bGUtdGVybS1wYXJ0aWNsZSI+PHNwYW4gY2xh' ||
    'c3M9InJ1bGUtZXhhbXBsZS1hciIgZGlyPSJydGwiIGxhbmc9ImFyIj48c3BhbiBjbGFzcz0i' ||
    'YXItdG9uZS1wYXJ0aWNsZSI+2YTZjti52Y7ZhNmR2Y48L3NwYW4+IDxzcGFuIGNsYXNzPSJh' ||
    'ci10b25lLW5hc2IiPtin2YTZkNin2K7Zktiq2ZDYqNmO2KfYsdmOPC9zcGFuPiA8c3BhbiBj' ||
    'bGFzcz0iYXItdG9uZS1yYWYiPtiz2Y7Zh9mS2YTZjDwvc3Bhbj4uPC9zcGFuPjxzcGFuIGNs' ||
    'YXNzPSJydWxlLWV4YW1wbGUtcnUiPtCd0LDQtNC10Y7RgdGMLCDRjdC60LfQsNC80LXQvSDQ' ||
    'u9GR0LPQutC40LkuPC9zcGFuPjwvZGl2PjxkaXYgY2xhc3M9InJ1bGUtZXhhbXBsZS1jYXJk' ||
    'IHJ1bGUtdGVybS1wYXJ0aWNsZSI+PHNwYW4gY2xhc3M9InJ1bGUtZXhhbXBsZS1hciIgZGly' ||
    'PSJydGwiIGxhbmc9ImFyIj48c3BhbiBjbGFzcz0iYXItdG9uZS1wYXJ0aWNsZSI+2YTZjtmK' ||
    '2ZLYqtmOPC9zcGFuPiA8c3BhbiBjbGFzcz0iYXItdG9uZS1uYXNiIj7ZhdmP2K3ZjtmF2ZHZ' ||
    'jtiv2YvYpzwvc3Bhbj4gPHNwYW4gY2xhc3M9ImFyLXRvbmUtcmFmIj7Yt9mO2KjZkNmK2KjZ' ||
    'jDwvc3Bhbj4uPC9zcGFuPjxzcGFuIGNsYXNzPSJydWxlLWV4YW1wbGUtcnUiPtCl0L7RgtC1' ||
    '0LvQvtGB0Ywg0LHRiywg0YfRgtC+0LHRiyDQnNGD0YXQsNC80LzQsNC0INCx0YvQuyDQstGA' ||
    '0LDRh9C+0LwuPC9zcGFuPjwvZGl2PjwvZGl2PjwvZGl2Pg==',
    'base64'
  ), 'UTF8');

  new_examples_1248 constant text := convert_from(decode(
    'PGRpdiBjbGFzcz0icnVsZS1zdHVkeS1jYXJkIj48c3BhbiBjbGFzcz0icnVsZS1jYXJkLWtp' ||
    'Y2tlciI+0J7RgdGC0LDQu9GM0L3Ri9C1INGB0ZHRgdGC0YDRiyDYpdmQ2YbZkdmOPC9zcGFu' ||
    'PjxkaXYgY2xhc3M9InJ1bGUtZXhhbXBsZS1saXN0Ij48ZGl2IGNsYXNzPSJydWxlLWV4YW1w' ||
    'bGUtY2FyZCBydWxlLXRlcm0tcGFydGljbGUiPjxzcGFuIGNsYXNzPSJydWxlLWV4YW1wbGUt' ||
    'YXIiIGRpcj0icnRsIiBsYW5nPSJhciI+2LPZjtmF2ZDYudmS2KrZjyA8c3BhbiBjbGFzcz0i' ||
    'YXItdG9uZS1wYXJ0aWNsZSI+2KPZjtmG2ZHZjjwvc3Bhbj4gPHNwYW4gY2xhc3M9ImFyLXRv' ||
    'bmUtbmFzYiI+2KfZhNmS2YXZj9iv2Y7YsdmR2ZDYs9mOPC9zcGFuPiA8c3BhbiBjbGFzcz0i' ||
    'YXItdG9uZS1yYWYiPtmF2Y7YsdmQ2YrYttmMPC9zcGFuPi48L3NwYW4+PHNwYW4gY2xhc3M9' ||
    'InJ1bGUtZXhhbXBsZS1ydSI+0K8g0YPRgdC70YvRiNCw0LssINGH0YLQviDQv9GA0LXQv9C+' ||
    '0LTQsNCy0LDRgtC10LvRjCDQsdC+0LvQtdC9Ljwvc3Bhbj48L2Rpdj48ZGl2IGNsYXNzPSJy' ||
    'dWxlLWV4YW1wbGUtY2FyZCBydWxlLXRlcm0tcGFydGljbGUiPjxzcGFuIGNsYXNzPSJydWxl' ||
    'LWV4YW1wbGUtYXIiIGRpcj0icnRsIiBsYW5nPSJhciI+2KfZhNiz2ZHZjtmK2ZHZjtin2LHZ' ||
    'jtip2Y8g2YLZjtiv2ZDZitmF2Y7YqdmM2IwgPHNwYW4gY2xhc3M9ImFyLXRvbmUtcGFydGlj' ||
    'bGUiPtmE2Y7Zg9mQ2YbZkdmO2YfZjtinPC9zcGFuPiA8c3BhbiBjbGFzcz0iYXItdG9uZS1y' ||
    'YWYiPtmC2Y7ZiNmQ2YrZkdmO2KnZjDwvc3Bhbj4uPC9zcGFuPjxzcGFuIGNsYXNzPSJydWxl' ||
    'LWV4YW1wbGUtcnUiPtCc0LDRiNC40L3QsCDRgdGC0LDRgNCw0Y8sINC90L4g0L7QvdCwINC6' ||
    '0YDQtdC/0LrQsNGPLjwvc3Bhbj48L2Rpdj48ZGl2IGNsYXNzPSJydWxlLWV4YW1wbGUtY2Fy' ||
    'ZCBydWxlLXRlcm0tcGFydGljbGUiPjxzcGFuIGNsYXNzPSJydWxlLWV4YW1wbGUtYXIiIGRp' ||
    'cj0icnRsIiBsYW5nPSJhciI+PHNwYW4gY2xhc3M9ImFyLXRvbmUtcGFydGljbGUiPtmE2Y7Z' ||
    'itmS2KrZjjwvc3Bhbj4gPHNwYW4gY2xhc3M9ImFyLXRvbmUtbmFzYiI+2YXZj9it2Y7ZhdmR' ||
    '2Y7Yr9mL2Kc8L3NwYW4+IDxzcGFuIGNsYXNzPSJhci10b25lLXJhZiI+2LfZjtio2ZDZitio' ||
    '2Yw8L3NwYW4+Ljwvc3Bhbj48c3BhbiBjbGFzcz0icnVsZS1leGFtcGxlLXJ1Ij7QpdC+0YLQ' ||
    'tdC70L7RgdGMINCx0YssINGH0YLQvtCx0Ysg0JzRg9GF0LDQvNC80LDQtCDQsdGL0Lsg0LLR' ||
    'gNCw0YfQvtC8Ljwvc3Bhbj48L2Rpdj48L2Rpdj48L2Rpdj48ZGl2IGNsYXNzPSJydWxlLXN0' ||
    'dWR5LWNhcmQiPjxzcGFuIGNsYXNzPSJydWxlLWNhcmQta2lja2VyIj7QndCw0L/QuNGB0LDQ' ||
    'vdC40LUg0Lgg0L/RgNC+0LjQt9C90L7RiNC10L3QuNC1INmE2Y7Zg9mQ2YbZkdmOPC9zcGFu' ||
    'PjxzcGFuIGNsYXNzPSJydWxlLW1haW4tYXIiIGRpcj0icnRsIiBsYW5nPSJhciI+2KrZj9mD' ||
    '2ZLYqtmO2KjZjyA8c3BhbiBjbGFzcz0iYXItdG9uZS1wYXJ0aWNsZSI+2YTZjtmD2ZDZhtmR' ||
    '2Y48L3NwYW4+INmH2bDZg9mO2LDZjtinOiA8c3BhbiBjbGFzcz0iYXItdG9uZS1wYXJ0aWNs' ||
    'ZSI+2YTZjtmD2ZDZhtmR2Y48L3NwYW4+2Iwg2YjZjtiq2Y/ZhtmS2LfZjtmC2Y86IDxzcGFu' ||
    'IGNsYXNzPSJhci10b25lLXBhcnRpY2xlIj7ZhNmO2KfZg9mQ2YbZkdmOPC9zcGFuPi48L3Nw' ||
    'YW4+PHAgY2xhc3M9InJ1bGUtc3R1ZHktdGV4dCI+0JIg0YjQsNGA0YXQtSDQvtGC0LTQtdC7' ||
    '0YzQvdC+INC+0YLQvNC10YfQtdC90L46INC/0L7RgdC70LUgPHNwYW4gY2xhc3M9ImFyLWlu' ||
    'bGluZSIgZGlyPSJydGwiIGxhbmc9ImFyIj7ZhDwvc3Bhbj4g0LDQu9C40YQg0L3QsCDQv9C4' ||
    '0YHRjNC80LUg0L3QtSDRgdGC0LDQstC40YLRgdGPLCDRhdC+0YLRjyDQsiDQv9GA0L7QuNC3' ||
    '0L3QvtGI0LXQvdC40Lgg0YHQu9GL0YjQuNGC0YHRjyDQtNC+0LvQs9C40Lkg0LfQstGD0Log' ||
    'wqvQsMK7LjwvcD48L2Rpdj48ZGl2IGNsYXNzPSJydWxlLXN0dWR5LWNhcmQiPjxzcGFuIGNs' ||
    'YXNzPSJydWxlLWNhcmQta2lja2VyIj7QlNCy0LAg0LfQvdCw0YfQtdC90LjRjyDZg9mO2KPZ' ||
    'jtmG2ZHZjjwvc3Bhbj48ZGl2IGNsYXNzPSJydWxlLWV4YW1wbGUtbGlzdCI+PGRpdiBjbGFz' ||
    'cz0icnVsZS1leGFtcGxlLWNhcmQgcnVsZS10ZXJtLXBhcnRpY2xlIj48c3BhbiBjbGFzcz0i' ||
    'cnVsZS1leGFtcGxlLWFyIiBkaXI9InJ0bCIgbGFuZz0iYXIiPjxzcGFuIGNsYXNzPSJhci10' ||
    'b25lLXBhcnRpY2xlIj7Zg9mO2KPZjtmG2ZHZjtmH2Y88L3NwYW4+IDxzcGFuIGNsYXNzPSJh' ||
    'ci10b25lLXJhZiI+2YXZj9iv2Y7YsdmR2ZDYs9mMINis2Y7Yr9mQ2YrYr9mMPC9zcGFuPi48' ||
    'L3NwYW4+PHNwYW4gY2xhc3M9InJ1bGUtZXhhbXBsZS1ydSI+0JfQtNC10YHRjCA8c3BhbiBj' ||
    'bGFzcz0iYXItaW5saW5lIGFyLXRvbmUtcGFydGljbGUiIGRpcj0icnRsIiBsYW5nPSJhciI+' ||
    '2YPZjtij2Y7ZhtmR2Y48L3NwYW4+INCy0YvRgNCw0LbQsNC10YIg0L/RgNC10LTQv9C+0LvQ' ||
    'vtC20LXQvdC40LUg4oCUIDxzcGFuIGNsYXNzPSJhci1pbmxpbmUgYXItdG9uZS1wYXJ0aWNs' ||
    'ZSIgZGlyPSJydGwiIGxhbmc9ImFyIj7Yp9mE2LjZkdmO2YbZkdmPPC9zcGFuPjogPHNwYW4g' ||
    'Y2xhc3M9ImFyLWlubGluZSIgZGlyPSJydGwiIGxhbmc9ImFyIj7Yo9mO2LjZj9mG2ZHZj9mH' ||
    '2Y8g2YXZj9iv2Y7YsdmR2ZDYs9mL2Kcg2KzZjtiv2ZDZitiv2YvYpzwvc3Bhbj4g4oCUIMKr' ||
    '0JTRg9C80LDRjiwg0YfRgtC+INC+0L0g0L3QvtCy0YvQuSDQv9GA0LXQv9C+0LTQsNCy0LDR' ||
    'gtC10LvRjMK7Ljwvc3Bhbj48L2Rpdj48ZGl2IGNsYXNzPSJydWxlLWV4YW1wbGUtY2FyZCBy' ||
    'dWxlLXRlcm0tcGFydGljbGUiPjxzcGFuIGNsYXNzPSJydWxlLWV4YW1wbGUtYXIiIGRpcj0i' ||
    'cnRsIiBsYW5nPSJhciI+PHNwYW4gY2xhc3M9ImFyLXRvbmUtcGFydGljbGUiPtmD2Y7Yo9mO' ||
    '2YbZkdmOPC9zcGFuPiA8c3BhbiBjbGFzcz0iYXItdG9uZS1uYXNiIj7Yp9mE2ZLZhdmO2LPZ' ||
    'ktis2ZDYr9mOPC9zcGFuPiA8c3BhbiBjbGFzcz0iYXItdG9uZS1yYWYiPtmF2Y7Yr9mS2LHZ' ||
    'jtiz2Y7YqdmMPC9zcGFuPi48L3NwYW4+PHNwYW4gY2xhc3M9InJ1bGUtZXhhbXBsZS1ydSI+' ||
    '0JfQtNC10YHRjCA8c3BhbiBjbGFzcz0iYXItaW5saW5lIGFyLXRvbmUtcGFydGljbGUiIGRp' ||
    'cj0icnRsIiBsYW5nPSJhciI+2YPZjtij2Y7ZhtmR2Y48L3NwYW4+INCy0YvRgNCw0LbQsNC1' ||
    '0YIg0YPQv9C+0LTQvtCx0LvQtdC90LjQtSDigJQgPHNwYW4gY2xhc3M9ImFyLWlubGluZSBh' ||
    'ci10b25lLXBhcnRpY2xlIiBkaXI9InJ0bCIgbGFuZz0iYXIiPtin2YTYqtmR2Y7YtNmS2KjZ' ||
    'kNmK2YfZjzwvc3Bhbj46IMKr0JzQtdGH0LXRgtGMINGB0LvQvtCy0L3QviDRiNC60L7Qu9Cw' ||
    'wrsuPC9zcGFuPjwvZGl2PjwvZGl2PjwvZGl2PjxkaXYgY2xhc3M9InJ1bGUtc3R1ZHktY2Fy' ||
    'ZCI+PHNwYW4gY2xhc3M9InJ1bGUtY2FyZC1raWNrZXIiPtCU0LLQsCDQt9C90LDRh9C10L3Q' ||
    'uNGPINmE2Y7YudmO2YTZkdmOPC9zcGFuPjxkaXYgY2xhc3M9InJ1bGUtZXhhbXBsZS1saXN0' ||
    'Ij48ZGl2IGNsYXNzPSJydWxlLWV4YW1wbGUtY2FyZCBydWxlLXRlcm0tcGFydGljbGUiPjxz' ||
    'cGFuIGNsYXNzPSJydWxlLWV4YW1wbGUtYXIiIGRpcj0icnRsIiBsYW5nPSJhciI+PHNwYW4g' ||
    'Y2xhc3M9ImFyLXRvbmUtcGFydGljbGUiPtmE2Y7YudmO2YTZkdmOPC9zcGFuPiA8c3BhbiBj' ||
    'bGFzcz0iYXItdG9uZS1uYXNiIj7Yp9mE2ZDYp9iu2ZLYqtmQ2KjZjtin2LHZjjwvc3Bhbj4g' ||
    'PHNwYW4gY2xhc3M9ImFyLXRvbmUtcmFmIj7Ys9mO2YfZktmE2Yw8L3NwYW4+Ljwvc3Bhbj48' ||
    'c3BhbiBjbGFzcz0icnVsZS1leGFtcGxlLXJ1Ij7Ql9C00LXRgdGMIDxzcGFuIGNsYXNzPSJh' ||
    'ci1pbmxpbmUgYXItdG9uZS1wYXJ0aWNsZSIgZGlyPSJydGwiIGxhbmc9ImFyIj7ZhNmO2LnZ' ||
    'jtmE2ZHZjjwvc3Bhbj4g0LLRi9GA0LDQttCw0LXRgiDQvdCw0LTQtdC20LTRgyDigJQgPHNw' ||
    'YW4gY2xhc3M9ImFyLWlubGluZSBhci10b25lLXBhcnRpY2xlIiBkaXI9InJ0bCIgbGFuZz0i' ||
    'YXIiPtin2YTYqtmR2Y7YsdmO2KzZkdmQ2Yo8L3NwYW4+OiDCq9Cd0LDQtNC10Y7RgdGMLCDR' ||
    'jdC60LfQsNC80LXQvSDQu9GR0LPQutC40LnCuy48L3NwYW4+PC9kaXY+PGRpdiBjbGFzcz0i' ||
    'cnVsZS1leGFtcGxlLWNhcmQgcnVsZS10ZXJtLXBhcnRpY2xlIj48c3BhbiBjbGFzcz0icnVs' ||
    'ZS1leGFtcGxlLWFyIiBkaXI9InJ0bCIgbGFuZz0iYXIiPjxzcGFuIGNsYXNzPSJhci10b25l' ||
    'LXBhcnRpY2xlIj7ZhNmO2LnZjtmE2ZHZjjwvc3Bhbj4gPHNwYW4gY2xhc3M9ImFyLXRvbmUt' ||
    'bmFzYiI+2KfZhNmQ2KfYrtmS2KrZkNio2Y7Yp9ix2Y48L3NwYW4+IDxzcGFuIGNsYXNzPSJh' ||
    'ci10b25lLXJhZiI+2LXZjti52ZLYqNmMPC9zcGFuPi48L3NwYW4+PHNwYW4gY2xhc3M9InJ1' ||
    'bGUtZXhhbXBsZS1ydSI+0JfQtNC10YHRjCA8c3BhbiBjbGFzcz0iYXItaW5saW5lIGFyLXRv' ||
    'bmUtcGFydGljbGUiIGRpcj0icnRsIiBsYW5nPSJhciI+2YTZjti52Y7ZhNmR2Y48L3NwYW4+' ||
    'INCy0YvRgNCw0LbQsNC10YIg0L7Qv9Cw0YHQtdC90LjQtSDigJQgPHNwYW4gY2xhc3M9ImFy' ||
    'LWlubGluZSBhci10b25lLXBhcnRpY2xlIiBkaXI9InJ0bCIgbGFuZz0iYXIiPtin2YTZktil' ||
    '2ZDYtNmS2YHZjtin2YLZjzwvc3Bhbj46IMKr0JXRgdGC0Ywg0L7Qv9Cw0YHQtdC90LjQtSwg' ||
    '0YfRgtC+INGN0LrQt9Cw0LzQtdC9INGC0YDRg9C00L3Ri9C5wrsuPC9zcGFuPjwvZGl2Pjwv' ||
    'ZGl2PjwvZGl2Pg==',
    'base64'
  ), 'UTF8');

  old_main_1251 constant text := convert_from(decode(
    'PHNwYW4gY2xhc3M9InJ1bGUtbWFpbi1hciIgZGlyPSJydGwiIGxhbmc9ImFyIj48c3BhbiBj' ||
    'bGFzcz0iYXItdG9uZS1wYXJ0aWNsZSI+2KPZjtmF2ZI8L3NwYW4+INmE2ZDYqtmO2LnZktmK' ||
    '2ZDZitmG2ZAg2KPZjtit2Y7Yr9mQINin2YTZktij2Y7ZhdmS2LHZjtmK2ZLZhtmQ2Iwg2YjZ' ||
    'jjxzcGFuIGNsYXNzPSJhci10b25lLXBhcnRpY2xlIj7Yo9mO2YjZkjwvc3Bhbj4g2KrZj9iz' ||
    '2ZLYqtmO2LnZktmF2Y7ZhNmPINmB2ZDZiiDYp9mE2ZDYp9iz2ZLYqtmQ2YHZktmH2Y7Yp9mF' ||
    '2ZAg2YjZjti62Y7ZitmS2LHZkNmH2ZAuPC9zcGFuPg==',
    'base64'
  ), 'UTF8');

  new_main_1251 constant text := convert_from(decode(
    'PHNwYW4gY2xhc3M9InJ1bGUtbWFpbi1hciIgZGlyPSJydGwiIGxhbmc9ImFyIj48c3BhbiBj' ||
    'bGFzcz0iYXItdG9uZS1wYXJ0aWNsZSI+2KPZjtmF2ZI8L3NwYW4+INmE2ZDYqtmO2LnZktmK' ||
    '2ZDZitmG2ZAg2KPZjtit2Y7Yr9mQINin2YTZktij2Y7ZhdmS2LHZjtmK2ZLZhtmQ2Iwg2YjZ' ||
    'jtmK2Y7Yo9mS2KrZkNmKINin2YTZktmF2Y7Ys9mS2KTZj9mI2YTZjyDYudmO2YbZktmH2Y8g' ||
    '2KjZjti52ZLYr9mOINin2YTZktmH2Y7ZhdmS2LLZjtip2ZAg2YXZj9io2Y7Yp9i02Y7YsdmO' ||
    '2KnZi9iMINmI2Y7ZitmP2KzZjtin2KjZjyDYqNmQ2KrZjti52ZLZitmQ2YrZhtmQINij2Y7Y' ||
    'rdmO2K/ZkCDYp9mE2ZLYo9mO2YXZktix2Y7ZitmS2YbZkNiMINmE2Y7YpyDYqNmQ2YbZjti5' ||
    '2Y7ZhdmSINij2Y7ZiNmSINmE2Y7Ypy4g2YjZjjxzcGFuIGNsYXNzPSJhci10b25lLXBhcnRp' ||
    'Y2xlIj7Yo9mO2YjZkjwvc3Bhbj4g2KrZj9iz2ZLYqtmO2LnZktmF2Y7ZhNmPINmB2ZDZiiDY' ||
    'p9mE2ZDYp9iz2ZLYqtmQ2YHZktmH2Y7Yp9mF2ZAg2YjZjti62Y7ZitmS2LHZkNmH2ZAuPC9z' ||
    'cGFuPg==',
    'base64'
  ), 'UTF8');

  old_verse_1251 constant text := convert_from(decode(
    'PGRpdiBjbGFzcz0icnVsZS1leGFtcGxlLWNhcmQiPjxzcGFuIGNsYXNzPSJydWxlLWV4YW1w' ||
    'bGUtYXIiIGRpcj0icnRsIiBsYW5nPSJhciI+2YLZjtin2YTZjiDYqtmO2LnZjtin2YTZjtmJ' ||
    'OiDvtL/Yo9mO2LHZjtin2LrZkNio2Ywg2KPZjtmG2KrZjiDYudmO2YbboSDYodmO2KfZhNmQ' ||
    '2YfZjtiq2ZDZiiDZitmO2bDZk9il2ZDYqNuh2LHZjtmw2YfZkNmK2YXZj9uW77S+PC9zcGFu' ||
    'PjxzcGFuIGNsYXNzPSJydWxlLWV4YW1wbGUtcnUiPtCS0YHQtdCy0YvRiNC90LjQuSDRgdC6' ||
    '0LDQt9Cw0Ls6IMKr0J3QtdGD0LbQtdC70Lgg0YLRiyDQvtGC0LLQtdGA0LPQsNC10YjRjCDQ' ||
    'vNC+0LjRhSDQsdC+0LPQvtCyLCDQviDQmNCx0YDQsNGF0LjQvD/Cuzwvc3Bhbj48L2Rpdj4=',
    'base64'
  ), 'UTF8');

  examples_marker_1251 constant text := convert_from(decode(
    'PGRpdiBjbGFzcz0icnVsZS1zdHVkeS1jYXJkIj48c3BhbiBjbGFzcz0icnVsZS1jYXJkLWtp' ||
    'Y2tlciI+0J/RgNC40LzQtdGA0Ys8L3NwYW4+',
    'base64'
  ), 'UTF8');

  context_1251 constant text := convert_from(decode(
    'PGRpdiBjbGFzcz0icnVsZS1zdHVkeS1jYXJkIj48c3BhbiBjbGFzcz0icnVsZS1jYXJkLWtp' ||
    'Y2tlciI+0J/QvtGH0LXQvNGDINC/0YDQuNC30L3QsNC6INGB0YLQvtC40YIg0L/QvtGB0LvQ' ||
    'tSDRhdCw0LzQt9GLPC9zcGFuPjxkaXYgY2xhc3M9InJ1bGUtZXhhbXBsZS1saXN0Ij48ZGl2' ||
    'IGNsYXNzPSJydWxlLWV4YW1wbGUtY2FyZCBydWxlLXRlcm0tcGFydGljbGUiPjxzcGFuIGNs' ||
    'YXNzPSJydWxlLWV4YW1wbGUtYXIgcnVsZS10YWJsZS12YWxpZCIgZGlyPSJydGwiIGxhbmc9' ||
    'ImFyIj48c3BhbiBjbGFzcz0iYXItdG9uZS1wYXJ0aWNsZSI+2KPZjjwvc3Bhbj7ZhdmP2KzZ' ||
    'ktiq2Y7Zh9mQ2K/ZjCDYo9mO2YbZktiq2Y4gPHNwYW4gY2xhc3M9ImFyLXRvbmUtcGFydGlj' ||
    'bGUiPtij2Y7ZhdmSPC9zcGFuPiDZg9mO2LPZktmE2Y7Yp9mG2Y/Ynzwvc3Bhbj48c3BhbiBj' ||
    'bGFzcz0icnVsZS1leGFtcGxlLXJ1Ij7QotGLINGB0YLQsNGA0LDRgtC10LvRjNC90YvQuSDQ' ||
    'uNC70Lgg0LvQtdC90LjQstGL0Lk/INCi0LDQuiDQutCw0Log0YHQv9GA0LDRiNC40LLQsNGO' ||
    '0YIg0LjQvNC10L3QvdC+INC+INGB0YLQsNGA0LDRgtC10LvRjNC90L7RgdGC0Lgg0LjQu9C4' ||
    'INC70LXQvdC4LCDRgdC70L7QstC+IDxzcGFuIGNsYXNzPSJhci1pbmxpbmUgYXItdG9uZS1z' ||
    'dWJqZWN0IiBkaXI9InJ0bCIgbGFuZz0iYXIiPtmF2Y/YrNmS2KrZjtmH2ZDYr9mMPC9zcGFu' ||
    'PiDRgdGC0LDQstC40YLRgdGPINC90LXQv9C+0YHRgNC10LTRgdGC0LLQtdC90L3QviDQv9C+' ||
    '0YHQu9C1INCy0L7Qv9GA0L7RgdC40YLQtdC70YzQvdC+0Lkg0YXQsNC80LfRiy48L3NwYW4+' ||
    'PC9kaXY+PGRpdiBjbGFzcz0icnVsZS1leGFtcGxlLWNhcmQgcnVsZS10ZXJtLXBhcnRpY2xl' ||
    'Ij48c3BhbiBjbGFzcz0icnVsZS1leGFtcGxlLWFyIHJ1bGUtdGFibGUtaW52YWxpZCIgZGly' ||
    'PSJydGwiIGxhbmc9ImFyIj7Yo9mO2KPZjtmG2ZLYqtmOINmF2Y/YrNmS2KrZjtmH2ZDYr9mM' ||
    'INij2Y7ZhdmSINmD2Y7Ys9mS2YTZjtin2YbZj9ifPC9zcGFuPjxzcGFuIGNsYXNzPSJydWxl' ||
    'LWV4YW1wbGUtcnUiPtCd0LUg0L/QviDQv9C+0YDRj9C00LrRgywg0YPQutCw0LfQsNC90L3Q' ||
    'vtC80YMg0LIg0YjQsNGA0YXQtTog0L/QvtGB0LvQtSDRhdCw0LzQt9GLINC/0L7RgdGC0LDQ' ||
    'stC70LXQvdC+IDxzcGFuIGNsYXNzPSJhci1pbmxpbmUiIGRpcj0icnRsIiBsYW5nPSJhciI+' ||
    '2KPZjtmG2ZLYqtmOPC9zcGFuPiwg0YXQvtGC0Y8g0LLQvtC/0YDQvtGBINC+0YLQvdC+0YHQ' ||
    'uNGC0YHRjyDQuiDQv9GA0LjQt9C90LDQutGDLjwvc3Bhbj48L2Rpdj48L2Rpdj48L2Rpdj48' ||
    'ZGl2IGNsYXNzPSJydWxlLXN0dWR5LWNhcmQiPjxzcGFuIGNsYXNzPSJydWxlLWNhcmQta2lj' ||
    'a2VyIj7Qn9C+0YfQtdC80YMg0LfQtNC10YHRjCDQv9GA0LjQstC10LTRkdC9INCw0Y/Rgjwv' ||
    'c3Bhbj48ZGl2IGNsYXNzPSJydWxlLWV4YW1wbGUtbGlzdCI+PGRpdiBjbGFzcz0icnVsZS1l' ||
    'eGFtcGxlLWNhcmQiPjxzcGFuIGNsYXNzPSJydWxlLWV4YW1wbGUtYXIiIGRpcj0icnRsIiBs' ||
    'YW5nPSJhciI+2YLZjtin2YTZjiDYqtmO2LnZjtin2YTZjtmJOiDvtL/Yo9mO2LHZjtin2LrZ' ||
    'kNio2Ywg2KPZjtmG2KrZjiDYudmO2YbboSDYodmO2KfZhNmQ2YfZjtiq2ZDZiiDZitmO2bDZ' ||
    'k9il2ZDYqNuh2LHZjtmw2YfZkNmK2YXZj9uW77S+PC9zcGFuPjxzcGFuIGNsYXNzPSJydWxl' ||
    'LWV4YW1wbGUtcnUiPtCS0YHQtdCy0YvRiNC90LjQuSDRgdC60LDQt9Cw0Ls6IMKr0J3QtdGD' ||
    '0LbQtdC70Lgg0YLRiyDQvtGC0LLQvtGA0LDRh9C40LLQsNC10YjRjNGB0Y8g0L7RgiDQvNC+' ||
    '0LjRhSDQsdC+0LPQvtCyLCDQviDQmNCx0YDQsNGF0LjQvD/CuyDQkNGP0YIg0L/RgNC40LLQ' ||
    'tdC00ZHQvSDQsiDRiNCw0YDRhdC1INC60LDQuiDRgtC+0YIg0LbQtSDQv9C+0YDRj9C00L7Q' ||
    'ujog0LLQvtC/0YDQvtGBINC+0YLQvdC+0YHQuNGC0YHRjyDQuiDRgdC70L7QstGDIDxzcGFu' ||
    'IGNsYXNzPSJhci1pbmxpbmUgYXItdG9uZS1zdWJqZWN0IiBkaXI9InJ0bCIgbGFuZz0iYXIi' ||
    'Ptix2Y7Yp9i62ZDYqNmMPC9zcGFuPiDigJQgwqvQvtGC0LLQvtGA0LDRh9C40LLQsNGO0YnQ' ||
    'uNC50YHRj8K7LCDQv9C+0Y3RgtC+0LzRgyDQvtC90L4g0YHRgtC+0LjRgiDRgdGA0LDQt9GD' ||
    'INC/0L7RgdC70LUg0LLQvtC/0YDQvtGB0LjRgtC10LvRjNC90L7QuSDRhdCw0LzQt9GLLCDQ' ||
    'sCA8c3BhbiBjbGFzcz0iYXItaW5saW5lIiBkaXI9InJ0bCIgbGFuZz0iYXIiPtij2Y7ZhtmS' ||
    '2KrZjjwvc3Bhbj4g0YHQu9C10LTRg9C10YIg0LfQsCDQvdC40LwuPC9zcGFuPjwvZGl2Pjwv' ||
    'ZGl2PjwvZGl2Pg==',
    'base64'
  ), 'UTF8');

  old_india_1251 constant text := convert_from(decode(
    'PGRpdiBjbGFzcz0icnVsZS1leGFtcGxlLWNhcmQgcnVsZS10ZXJtLXBhcnRpY2xlIj48c3Bh' ||
    'biBjbGFzcz0icnVsZS1leGFtcGxlLWFyIiBkaXI9InJ0bCIgbGFuZz0iYXIiPjxzcGFuIGNs' ||
    'YXNzPSJhci10b25lLXBhcnRpY2xlIj7Yo9mOPC9zcGFuPtmF2ZDZhtmOINin2YTZktmH2ZDZ' ||
    'htmS2K/ZkCDYo9mO2YbZktiq2Y4gPHNwYW4gY2xhc3M9ImFyLXRvbmUtcGFydGljbGUiPtij' ||
    '2Y7ZhdmSPC9zcGFuPiDZhdmQ2YbZkiDYqNmO2KfZg9mQ2LPZktiq2Y7Yp9mG2Y7Ynzwvc3Bh' ||
    'bj48c3BhbiBjbGFzcz0icnVsZS1leGFtcGxlLXJ1Ij7QotGLINC40Lcg0JjQvdC00LjQuCDQ' ||
    'uNC70Lgg0LjQtyDQn9Cw0LrQuNGB0YLQsNC90LA/PC9zcGFuPjwvZGl2Pg==',
    'base64'
  ), 'UTF8');

  new_india_1251 constant text := convert_from(decode(
    'PGRpdiBjbGFzcz0icnVsZS1leGFtcGxlLWNhcmQgcnVsZS10ZXJtLXBhcnRpY2xlIj48c3Bh' ||
    'biBjbGFzcz0icnVsZS1leGFtcGxlLWFyIiBkaXI9InJ0bCIgbGFuZz0iYXIiPjxzcGFuIGNs' ||
    'YXNzPSJhci10b25lLXBhcnRpY2xlIj7Yo9mOPC9zcGFuPtmF2ZDZhtmOINin2YTZktmH2ZDZ' ||
    'htmS2K/ZkCDYo9mO2YbZktiq2Y4gPHNwYW4gY2xhc3M9ImFyLXRvbmUtcGFydGljbGUiPtij' ||
    '2Y7ZhdmSPC9zcGFuPiDZhdmQ2YbZkiDYqNmO2KfZg9mQ2LPZktiq2Y7Yp9mG2Y7Ynzwvc3Bh' ||
    'bj48c3BhbiBjbGFzcz0icnVsZS1leGFtcGxlLXJ1Ij7QotGLINC40Lcg0JjQvdC00LjQuCDQ' ||
    'uNC70Lgg0LjQtyDQn9Cw0LrQuNGB0YLQsNC90LA/PC9zcGFuPjwvZGl2PjxkaXYgY2xhc3M9' ||
    'InJ1bGUtZXhhbXBsZS1jYXJkIHJ1bGUtdGVybS1wYXJ0aWNsZSI+PHNwYW4gY2xhc3M9InJ1' ||
    'bGUtZXhhbXBsZS1hciIgZGlyPSJydGwiIGxhbmc9ImFyIj7Yo9mO2YbZjtinINmF2ZDZhtmO' ||
    'INin2YTZktmH2ZDZhtmS2K/ZkC48L3NwYW4+PHNwYW4gY2xhc3M9InJ1bGUtZXhhbXBsZS1y' ||
    'dSI+0K8g0LjQtyDQmNC90LTQuNC4LiDQntGC0LLQtdGC0L7QvCDQvdCw0LfRi9Cy0LDRjtGC' ||
    'INCy0YvQsdGA0LDQvdC90YvQuSDQstCw0YDQuNCw0L3Rgjsg0L3QsCDQstC+0L/RgNC+0YEg' ||
    '0YEgPHNwYW4gY2xhc3M9ImFyLWlubGluZSBhci10b25lLXBhcnRpY2xlIiBkaXI9InJ0bCIg' ||
    'bGFuZz0iYXIiPtmH2Y7ZhdmS2LLZjtip2Y8g2KfZhNiq2ZHZjti52ZLZitmQ2YrZhtmQPC9z' ||
    'cGFuPiDQvdC1INC+0YLQstC10YfQsNGO0YIg0YLQvtC70YzQutC+INGB0LvQvtCy0LDQvNC4' ||
    'IDxzcGFuIGNsYXNzPSJhci1pbmxpbmUgYXItdG9uZS1wYXJ0aWNsZSIgZGlyPSJydGwiIGxh' ||
    'bmc9ImFyIj7ZhtmO2LnZjtmF2ZI8L3NwYW4+INC40LvQuCA8c3BhbiBjbGFzcz0iYXItaW5s' ||
    'aW5lIGFyLXRvbmUtcGFydGljbGUiIGRpcj0icnRsIiBsYW5nPSJhciI+2YTZjtinPC9zcGFu' ||
    'Pi48L3NwYW4+PC9kaXY+',
    'base64'
  ), 'UTF8');

  rule_1248 constant text := convert_from(decode(
    '2KXZkNmG2ZHZjiDZiNmO2KPZjtiu2Y7ZiNmO2KfYqtmP2YfZjtinINit2Y/YsdmP2YjZgdmM' ||
    'INiq2Y7Yr9mS2K7Zj9mE2Y8g2LnZjtmE2Y7ZiSDYp9mE2ZLYrNmP2YXZktmE2Y7YqdmQINin' ||
    '2YTZkNin2LPZktmF2ZDZitmR2Y7YqdmQINmB2Y7ZgtmO2LfZktiMINmB2Y7YqtmO2YbZkti1' ||
    '2ZDYqNmPINin2YTZktmF2Y/YqNmS2KrZjtiv2Y7Yo9mOINmI2Y7YqtmO2LHZktmB2Y7YudmP' ||
    'INin2YTZktiu2Y7YqNmO2LHZjtiMINmI2Y7YqtmO2KzZkti52Y7ZhNmPINin2YTZktmF2Y/Y' ||
    'qNmS2KrZjtiv2Y7Yo9mOINin2LPZktmF2YvYpyDZhNmO2YfZjtinINmI2Y7Yp9mE2ZLYrtmO' ||
    '2KjZjtix2Y4g2K7Zjtio2Y7YsdmL2Kcg2YTZjtmH2Y7Ypy4g2YjZjtmH2ZDZitmOOiDYpdmQ' ||
    '2YbZkdmO2Iwg2YjZjtij2Y7ZhtmR2Y7YjCDZiNmO2YTZjtmD2ZDZhtmR2Y7YjCDZiNmO2YPZ' ||
    'jtij2Y7ZhtmR2Y7YjCDZiNmO2YTZjti52Y7ZhNmR2Y7YjCDZiNmO2YTZjtmK2ZLYqtmOLiDZ' ||
    'iNmO2KrZjtij2ZLYqtmQ2Yog2YPZjtij2Y7ZhtmR2Y4g2YTZkNmE2KrZkdmO2LTZktio2ZDZ' ||
    'itmH2ZAg2YjZjtmE2ZDZhNi42ZHZjtmG2ZHZkNiMINmI2Y7YqtmO2KPZktiq2ZDZiiDZhNmO' ||
    '2LnZjtmE2ZHZjiDZhNmQ2YTYqtmR2Y7YsdmO2KzZkdmQ2Yog2YjZjtmE2ZDZhNmS2KXZkNi0' ||
    '2ZLZgdmO2KfZgtmQLiDZiNmO2KXZkNiw2Y7YpyDYr9mO2K7ZjtmE2Y7YqtmSINil2ZDZhtmR' ||
    '2Y4g2KPZjtmI2ZIg2YTZjti52Y7ZhNmR2Y4g2LnZjtmE2Y7ZiSDYttmO2YXZkNmK2LHZjdiM' ||
    'INin2KrZkdmO2LXZjtmE2Y4g2KjZkNmH2Y7YpyDYttmO2YXZkNmK2LHZjyDYp9mE2YbZkdmO' ||
    '2LXZktio2ZAg2KfZhNmS2YXZj9mG2Y7Yp9iz2ZDYqNmPLg==',
    'base64'
  ), 'UTF8');

  rule_1251 constant text := convert_from(decode(
    '2KPZjtmF2ZIg2YXZkNmG2ZIg2K3Zj9ix2Y/ZiNmB2ZAg2KfZhNmS2LnZjti32ZLZgdmQ2Iwg' ||
    '2YjZjtiq2Y/Ys9mS2KrZjti52ZLZhdmO2YTZjyDZgdmQ2Yog2KfZhNmQ2KfYs9mS2KrZkNmB' ||
    '2ZLZh9mO2KfZhdmQINio2Y7YudmS2K/ZjiDZh9mO2YXZktiy2Y7YqdmQINin2YTYqtmR2Y7Y' ||
    'udmS2YrZkNmK2YbZkCDZhNmQ2KrZjti52ZLZitmQ2YrZhtmQINij2Y7YrdmO2K/ZkCDYp9mE' ||
    '2ZLYo9mO2YXZktix2Y7ZitmS2YbZkNiMINmI2Y7ZitmO2KPZktiq2ZDZiiDYp9mE2ZLZhdmO' ||
    '2LPZktik2Y/ZiNmE2Y8g2LnZjtmG2ZLZh9mPINio2Y7YudmS2K/ZjiDYp9mE2ZLZh9mO2YXZ' ||
    'ktiy2Y7YqdmQINmF2Y/YqNmO2KfYtNmO2LHZjtip2YvYjCDZiNmO2KzZjtmI2Y7Yp9io2Y/Z' ||
    'h9mO2Kcg2YrZjtmD2Y/ZiNmG2Y8g2KjZkNiq2Y7YudmS2YrZkNmK2YbZkCDYo9mO2K3Zjtiv' ||
    '2ZAg2KfZhNmS2KPZjtmF2ZLYsdmO2YrZktmG2ZDYjCDZhNmO2Kcg2KjZkNmG2Y7YudmO2YXZ' ||
    'kiDYo9mO2YjZkiDZhNmO2KcuINmI2Y7Yo9mO2YjZkiDYrdmO2LHZktmB2Y8g2LnZjti32ZLZ' ||
    'gdmNINmK2Y/Ys9mS2KrZjti52ZLZhdmO2YTZjyDZgdmQ2Yog2KfZhNmQ2KfYs9mS2KrZkNmB' ||
    '2ZLZh9mO2KfZhdmQINmI2Y7YutmO2YrZktix2ZDZh9mQLg==',
    'base64'
  ), 'UTF8');

  needle_1248_a constant text := convert_from(decode(
    '2YXZj9iv2Y7YsdmR2ZDYs9mMINis2Y7Yr9mQ2YrYr9mM',
    'base64'
  ), 'UTF8');

  needle_1248_b constant text := convert_from(decode(
    '2KfZhNmS2KXZkNi02ZLZgdmO2KfZgtmP',
    'base64'
  ), 'UTF8');

  needle_1251_a constant text := convert_from(decode(
    '2YXZj9is2ZLYqtmO2YfZkNiv2Ywg2KPZjtmG2ZLYqtmO',
    'base64'
  ), 'UTF8');

  needle_1251_b constant text := convert_from(decode(
    '2KPZjtmG2Y7YpyDZhdmQ2YbZjiDYp9mE2ZLZh9mQ2YbZktiv2ZA=',
    'base64'
  ), 'UTF8');

  needle_1251_c constant text := convert_from(decode(
    '0J/QvtGH0LXQvNGDINC30LTQtdGB0Ywg0L/RgNC40LLQtdC00ZHQvSDQsNGP0YI=',
    'base64'
  ), 'UTF8');

  needle_1251_d constant text := convert_from(decode(
    '77S/2KPZjtix2Y7Yp9i62ZDYqNmMINij2Y7Zhtiq2Y4=',
    'base64'
  ), 'UTF8');
begin
  select content
  into strict current_content
  from public.rules
  where id = 1248
    and course_name = course_name_target
    and lesson_number = '1'
    and sort_order = 1;

  if position(needle_1248_a in current_content) > 0
     and position(needle_1248_b in current_content) > 0 then
    update public.rules
    set
      rule_ar = rule_1248,
      summary = rule_1248
    where id = 1248
      and course_name = course_name_target
      and lesson_number = '1'
      and sort_order = 1;
  else
    if position(old_examples_1248 in current_content) = 0 then
      raise exception 'Book 2 rule 1248 no longer matches the audited precondition';
    end if;

    update public.rules
    set
      rule_ar = rule_1248,
      summary = rule_1248,
      content = replace(content, old_examples_1248, new_examples_1248)
    where id = 1248
      and course_name = course_name_target
      and lesson_number = '1'
      and sort_order = 1;
  end if;

  get diagnostics affected = row_count;
  if affected <> 1 then
    raise exception 'Expected one update for Book 2 rule 1248, got %', affected;
  end if;

  select content
  into strict current_content
  from public.rules
  where id = 1251
    and course_name = course_name_target
    and lesson_number = '1'
    and sort_order = 4;

  if position(needle_1251_a in current_content) > 0
     and position(needle_1251_b in current_content) > 0
     and position(needle_1251_c in current_content) > 0
     and position(needle_1251_d in current_content) > 0 then
    update public.rules
    set
      rule_ar = rule_1251,
      summary = rule_1251
    where id = 1251
      and course_name = course_name_target
      and lesson_number = '1'
      and sort_order = 4;
  else
    if position(old_main_1251 in current_content) = 0
       or position(old_verse_1251 in current_content) = 0
       or position(examples_marker_1251 in current_content) = 0
       or position(old_india_1251 in current_content) = 0 then
      raise exception 'Book 2 rule 1251 no longer matches the audited preconditions';
    end if;

    update public.rules
    set
      rule_ar = rule_1251,
      summary = rule_1251,
      content = replace(
        replace(
          replace(
            replace(content, old_main_1251, new_main_1251),
            old_verse_1251,
            ''
          ),
          examples_marker_1251,
          context_1251 || examples_marker_1251
        ),
        old_india_1251,
        new_india_1251
      )
    where id = 1251
      and course_name = course_name_target
      and lesson_number = '1'
      and sort_order = 4;
  end if;

  get diagnostics affected = row_count;
  if affected <> 1 then
    raise exception 'Expected one update for Book 2 rule 1251, got %', affected;
  end if;

  select content
  into strict current_content
  from public.rules
  where id = 1248;

  if position(needle_1248_a in current_content) = 0
     or position(needle_1248_b in current_content) = 0 then
    raise exception 'Book 2 rule 1248 lost required source context';
  end if;

  select content
  into strict current_content
  from public.rules
  where id = 1251;

  if position(needle_1251_a in current_content) = 0
     or position(needle_1251_b in current_content) = 0
     or position(needle_1251_c in current_content) = 0
     or position(needle_1251_d in current_content) = 0 then
    raise exception 'Book 2 rule 1251 lost required source context';
  end if;
end
$migration$;

commit;
