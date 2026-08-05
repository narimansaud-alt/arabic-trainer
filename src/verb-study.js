(function () {
  'use strict';

  var rootId = 'screen-verb-study';
  var endpoint = 'https://arabic-trainer-qutrub.narimansaud.workers.dev/conjugate';
  var state = { verb: '', forms: null, loading: false, error: '', modal: '', layout: 'table', tableMode: 'single', tense: 'past', voice: 'active', mood: 'plain' };
  var persons = {
    'Щ‡ЩЏЩ€ЩЋ': 'РћРЅ', 'Щ‡Щ€': 'РћРЅ', 'Щ‡ЩЏЩ…ЩЋШ§': 'РћРЅРё РґРІРѕРµ', 'Щ‡Щ…Ш§': 'РћРЅРё РґРІРѕРµ',
    'Щ‡ЩЏЩ…Щ’': 'РћРЅРё', 'Щ‡Щ…': 'РћРЅРё', 'Щ‡ЩђЩЉЩЋ': 'РћРЅР°', 'Щ‡ЩЉ': 'РћРЅР°',
    'Щ‡ЩЏЩ†Щ‘ЩЋ': 'РћРЅРё (Р¶.)', 'Щ‡Щ†': 'РћРЅРё (Р¶.)', 'ШЈЩЋЩ†Щ’ШЄЩЋ': 'РўС‹ (Рј.)', 'ШЈЩ†ШЄ': 'РўС‹',
    'ШЈЩЋЩ†Щ’ШЄЩђ': 'РўС‹ (Р¶.)', 'ШЈЩ†ШЄЩђ': 'РўС‹ (Р¶.)', 'ШЈЩЋЩ†Щ’ШЄЩЏЩ…ЩЋШ§': 'Р’С‹ РґРІРѕРµ', 'ШЈЩ†ШЄЩ…Ш§': 'Р’С‹ РґРІРѕРµ',
    'ШЈЩЋЩ†Щ’ШЄЩЏЩ…Щ’': 'Р’С‹ (Рј.)', 'ШЈЩ†ШЄЩ…': 'Р’С‹ (Рј.)', 'ШЈЩЋЩ†Щ’ШЄЩЏЩ†Щ‘ЩЋ': 'Р’С‹ (Р¶.)', 'ШЈЩ†ШЄЩ†': 'Р’С‹ (Р¶.)',
    'ШЈЩЋЩ†ЩЋШ§': 'РЇ', 'ШЈЩ†Ш§': 'РЇ', 'Щ†ЩЋШ­Щ’Щ†ЩЏ': 'РњС‹', 'Щ†Ш­Щ†': 'РњС‹'
  };
  var modes = [
    ['all', 'Р’СЃРµ С„РѕСЂРјС‹', 'Ш¬Щ…ЩЉШ№ Ш§Щ„ШЄШµШ±ЩЉЩЃШ§ШЄ', 'РџРѕР»РЅС‹Р№ РѕР±Р·РѕСЂ РІСЃРµС… РІСЂРµРјС‘РЅ, Р·Р°Р»РѕРіРѕРІ Рё РЅР°РєР»РѕРЅРµРЅРёР№.'],
    ['past-active', 'РџСЂРѕС€РµРґС€РµРµ', 'Ш§Щ„Щ…Ш§Ш¶ЩЉ Ш§Щ„Щ…Ш№Щ„Щ€Щ…', 'РџСЂРѕС€РµРґС€РµРµ РІСЂРµРјСЏ, РґРµР№СЃС‚РІРёС‚РµР»СЊРЅС‹Р№ Р·Р°Р»РѕРі.'],
    ['past-passive', 'РџСЂРѕС€РµРґС€РµРµ, СЃС‚СЂР°РґР°С‚РµР»СЊРЅРѕРµ', 'Ш§Щ„Щ…Ш§Ш¶ЩЉ Ш§Щ„Щ…Ш¬Щ‡Щ€Щ„', 'РџСЂРѕС€РµРґС€РµРµ РІСЂРµРјСЏ, СЃС‚СЂР°РґР°С‚РµР»СЊРЅС‹Р№ Р·Р°Р»РѕРі.'],
    ['present-active', 'РќР°СЃС‚РѕСЏС‰РµРµ', 'Ш§Щ„Щ…Ш¶Ш§Ш±Ш№ Ш§Щ„Щ…Ш№Щ„Щ€Щ…', 'РќР°СЃС‚РѕСЏС‰РµРµ РёР»Рё Р±СѓРґСѓС‰РµРµ, РґРµР№СЃС‚РІРёС‚РµР»СЊРЅС‹Р№ Р·Р°Р»РѕРі.'],
    ['present-passive', 'РќР°СЃС‚РѕСЏС‰РµРµ, СЃС‚СЂР°РґР°С‚РµР»СЊРЅРѕРµ', 'Ш§Щ„Щ…Ш¶Ш§Ш±Ш№ Ш§Щ„Щ…Ш¬Щ‡Щ€Щ„', 'РќР°СЃС‚РѕСЏС‰РµРµ РёР»Рё Р±СѓРґСѓС‰РµРµ, СЃС‚СЂР°РґР°С‚РµР»СЊРЅС‹Р№ Р·Р°Р»РѕРі.'],
    ['subjunctive', 'РЎРѕСЃР»Р°РіР°С‚РµР»СЊРЅРѕРµ', 'Ш§Щ„Щ…Ш¶Ш§Ш±Ш№ Ш§Щ„Щ…Щ†ШµЩ€ШЁ', 'РЈРїРѕС‚СЂРµР±Р»СЏРµС‚СЃСЏ, РЅР°РїСЂРёРјРµСЂ, РїРѕСЃР»Рµ ШЈЩЋЩ†Щ’ Рё Щ„ЩЋЩ†Щ’.'],
    ['jussive', 'РЈСЃРµС‡С‘РЅРЅРѕРµ', 'Ш§Щ„Щ…Ш¶Ш§Ш±Ш№ Ш§Щ„Щ…Ш¬ШІЩ€Щ…', 'РЈРїРѕС‚СЂРµР±Р»СЏРµС‚СЃСЏ, РЅР°РїСЂРёРјРµСЂ, РїРѕСЃР»Рµ Щ„ЩЋЩ…Щ’.'],
    ['emphatic', 'РЈСЃРёР»РµРЅРЅРѕРµ', 'Ш§Щ„Щ…Ш¶Ш§Ш±Ш№ Ш§Щ„Щ…Ш¤ЩѓШЇ', 'РџРѕРґС‡С‘СЂРєРёРІР°РµС‚ РґРµР№СЃС‚РІРёРµ РЅСѓРЅРѕРј СѓСЃРёР»РµРЅРёСЏ.'],
    ['imperative', 'РџРѕРІРµР»РёС‚РµР»СЊРЅРѕРµ', 'Ш§Щ„ШЈЩ…Ш±', 'РџСЂРѕСЃСЊР±Р°, РїСЂРёРєР°Р· РёР»Рё СЃРѕРІРµС‚ РґР»СЏ РІС‚РѕСЂРѕРіРѕ Р»РёС†Р°.'],
    ['imperative-emphatic', 'РЈСЃРёР»РµРЅРЅРѕРµ РїРѕРІРµР»РёС‚РµР»СЊРЅРѕРµ', 'Ш§Щ„ШЈЩ…Ш± Ш§Щ„Щ…Ш¤ЩѓШЇ', 'РџРѕРІРµР»РёС‚РµР»СЊРЅР°СЏ С„РѕСЂРјР° СЃ СѓСЃРёР»РµРЅРёРµРј.']
  ];
  var patterns = [
    ['I', 'ЩЃЩЋШ№ЩЋЩ„ЩЋ / ЩЉЩЋЩЃЩ’Ш№ЩЋЩ„ЩЏ', 'Р‘Р°Р·РѕРІР°СЏ С‚СЂС‘С…Р±СѓРєРІРµРЅРЅР°СЏ РїРѕСЂРѕРґР°. Р“Р»Р°СЃРЅР°СЏ РЅР°СЃС‚РѕСЏС‰РµРіРѕ РІСЂРµРјРµРЅРё РѕРїСЂРµРґРµР»СЏРµС‚СЃСЏ СЃР»РѕРІР°СЂС‘Рј.', [['ЩѓЩЋШЄЩЋШЁЩЋ / ЩЉЩЋЩѓЩ’ШЄЩЏШЁЩЏ', 'РїРёСЃР°С‚СЊ'], ['Ш°ЩЋЩ‡ЩЋШЁЩЋ / ЩЉЩЋШ°Щ’Щ‡ЩЋШЁЩЏ', 'РёРґС‚Рё']]],
    ['II', 'ЩЃЩЋШ№Щ‘ЩЋЩ„ЩЋ / ЩЉЩЏЩЃЩЋШ№Щ‘ЩђЩ„ЩЏ', 'РЈСЃРёР»РµРЅРёРµ РґРµР№СЃС‚РІРёСЏ, РёРЅС‚РµРЅСЃРёРІРЅРѕСЃС‚СЊ РёР»Рё РїРѕР±СѓР¶РґРµРЅРёРµ Рє РґРµР№СЃС‚РІРёСЋ.', [['Ш№ЩЋЩ„Щ‘ЩЋЩ…ЩЋ / ЩЉЩЏШ№ЩЋЩ„Щ‘ЩђЩ…ЩЏ', 'РѕР±СѓС‡Р°С‚СЊ'], ['ЩѓЩЋШіЩ‘ЩЋШ±ЩЋ / ЩЉЩЏЩѓЩЋШіЩ‘ЩђШ±ЩЏ', 'СЂР°Р·Р±РёРІР°С‚СЊ РЅР° С‡Р°СЃС‚Рё']]],
    ['III', 'ЩЃЩЋШ§Ш№ЩЋЩ„ЩЋ / ЩЉЩЏЩЃЩЋШ§Ш№ЩђЩ„ЩЏ', 'Р§Р°СЃС‚Рѕ РІС‹СЂР°Р¶Р°РµС‚ РІР·Р°РёРјРЅРѕРµ РґРµР№СЃС‚РІРёРµ РёР»Рё РґРµР№СЃС‚РІРёРµ, РЅР°РїСЂР°РІР»РµРЅРЅРѕРµ РЅР° РґСЂСѓРіРѕРіРѕ.', [['ШґЩЋШ§Ш±ЩЋЩѓЩЋ / ЩЉЩЏШґЩЋШ§Ш±ЩђЩѓЩЏ', 'СѓС‡Р°СЃС‚РІРѕРІР°С‚СЊ'], ['ШіЩЋШ§Ш№ЩЋШЇЩЋ / ЩЉЩЏШіЩЋШ§Ш№ЩђШЇЩЏ', 'РїРѕРјРѕРіР°С‚СЊ']]],
    ['IV', 'ШЈЩЋЩЃЩ’Ш№ЩЋЩ„ЩЋ / ЩЉЩЏЩЃЩ’Ш№ЩђЩ„ЩЏ', 'Р§Р°СЃС‚Рѕ РїСЂРёРґР°С‘С‚ Р·РЅР°С‡РµРЅРёРµ РїРѕР±СѓР¶РґРµРЅРёСЏ, РІРІРµРґРµРЅРёСЏ РІ СЃРѕСЃС‚РѕСЏРЅРёРµ РёР»Рё РїРµСЂРµС…РѕРґРЅРѕСЃС‚Рё.', [['ШЈЩЋШ®Щ’Ш±ЩЋШ¬ЩЋ / ЩЉЩЏШ®Щ’Ш±ЩђШ¬ЩЏ', 'РІС‹РІРѕРґРёС‚СЊ'], ['ШЈЩЋШіЩ’Щ„ЩЋЩ…ЩЋ / ЩЉЩЏШіЩ’Щ„ЩђЩ…ЩЏ', 'РїСЂРµРґР°РІР°С‚СЊСЃСЏ, РїСЂРёРЅРёРјР°С‚СЊ РёСЃР»Р°Рј']]],
    ['V', 'ШЄЩЋЩЃЩЋШ№Щ‘ЩЋЩ„ЩЋ / ЩЉЩЋШЄЩЋЩЃЩЋШ№Щ‘ЩЋЩ„ЩЏ', 'Р’РѕР·РІСЂР°С‚РЅРѕРµ Р·РЅР°С‡РµРЅРёРµ РёР»Рё РїСЂРёРѕР±СЂРµС‚РµРЅРёРµ РєР°С‡РµСЃС‚РІР° РѕС‚ II РїРѕСЂРѕРґС‹.', [['ШЄЩЋШ№ЩЋЩ„Щ‘ЩЋЩ…ЩЋ / ЩЉЩЋШЄЩЋШ№ЩЋЩ„Щ‘ЩЋЩ…ЩЏ', 'СѓС‡РёС‚СЊСЃСЏ'], ['ШЄЩЋЩѓЩЋШіЩ‘ЩЋШ±ЩЋ / ЩЉЩЋШЄЩЋЩѓЩЋШіЩ‘ЩЋШ±ЩЏ', 'Р»РѕРјР°С‚СЊСЃСЏ РЅР° С‡Р°СЃС‚Рё']]],
    ['VI', 'ШЄЩЋЩЃЩЋШ§Ш№ЩЋЩ„ЩЋ / ЩЉЩЋШЄЩЋЩЃЩЋШ§Ш№ЩЋЩ„ЩЏ', 'Р’Р·Р°РёРјРЅРѕСЃС‚СЊ РёР»Рё РґРµР№СЃС‚РІРёРµ РЅРµСЃРєРѕР»СЊРєРёС… СѓС‡Р°СЃС‚РЅРёРєРѕРІ.', [['ШЄЩЋШ№ЩЋШ§Щ€ЩЋЩ†ЩЋ / ЩЉЩЋШЄЩЋШ№ЩЋШ§Щ€ЩЋЩ†ЩЏ', 'СЃРѕС‚СЂСѓРґРЅРёС‡Р°С‚СЊ'], ['ШЄЩЋШґЩЋШ§Ш±ЩЋЩѓЩЋ / ЩЉЩЋШЄЩЋШґЩЋШ§Ш±ЩЋЩѓЩЏ', 'РґРµР»РёС‚СЊ, СѓС‡Р°СЃС‚РІРѕРІР°С‚СЊ РІРјРµСЃС‚Рµ']]],
    ['VII', 'Ш§ЩђЩ†Щ’ЩЃЩЋШ№ЩЋЩ„ЩЋ / ЩЉЩЋЩ†Щ’ЩЃЩЋШ№ЩђЩ„ЩЏ', 'РћР±С‹С‡РЅРѕ РІРѕР·РІСЂР°С‚РЅРѕСЃС‚СЊ РёР»Рё СЂРµР·СѓР»СЊС‚Р°С‚ РґРµР№СЃС‚РІРёСЏ РЅР°Рґ РїСЂРµРґРјРµС‚РѕРј.', [['Ш§ЩђЩ†Щ’ЩѓЩЋШіЩЋШ±ЩЋ / ЩЉЩЋЩ†Щ’ЩѓЩЋШіЩђШ±ЩЏ', 'СЃР»РѕРјР°С‚СЊСЃСЏ'], ['Ш§ЩђЩ†Щ’ЩЃЩЋШЄЩЋШ­ЩЋ / ЩЉЩЋЩ†Щ’ЩЃЩЋШЄЩђШ­ЩЏ', 'РѕС‚РєСЂС‹РІР°С‚СЊСЃСЏ']]],
    ['VIII', 'Ш§ЩђЩЃЩ’ШЄЩЋШ№ЩЋЩ„ЩЋ / ЩЉЩЋЩЃЩ’ШЄЩЋШ№ЩђЩ„ЩЏ', 'РЈС‡Р°СЃС‚РёРµ СЃСѓР±СЉРµРєС‚Р° РІ РґРµР№СЃС‚РІРёРё, СѓСЃРёР»РёРµ РёР»Рё РїСЂРёРЅСЏС‚РёРµ РґРµР№СЃС‚РІРёСЏ.', [['Ш§ЩђШ¬Щ’ШЄЩЋЩ…ЩЋШ№ЩЋ / ЩЉЩЋШ¬Щ’ШЄЩЋЩ…ЩђШ№ЩЏ', 'СЃРѕР±РёСЂР°С‚СЊСЃСЏ'], ['Ш§ЩђШ­Щ’ШЄЩЋЩ…ЩЋЩ„ЩЋ / ЩЉЩЋШ­Щ’ШЄЩЋЩ…ЩђЩ„ЩЏ', 'РїРµСЂРµРЅРѕСЃРёС‚СЊ, С‚РµСЂРїРµС‚СЊ']]],
    ['IX', 'Ш§ЩђЩЃЩ’Ш№ЩЋЩ„Щ‘ЩЋ / ЩЉЩЋЩЃЩ’Ш№ЩЋЩ„Щ‘ЩЏ', 'Р РµРґРєР°СЏ РїРѕСЂРѕРґР°, РіР»Р°РІРЅС‹Рј РѕР±СЂР°Р·РѕРј РґР»СЏ С†РІРµС‚РѕРІ Рё С„РёР·РёС‡РµСЃРєРёС… РєР°С‡РµСЃС‚РІ.', [['Ш§ЩђШ­Щ’Щ…ЩЋШ±Щ‘ЩЋ / ЩЉЩЋШ­Щ’Щ…ЩЋШ±Щ‘ЩЏ', 'РєСЂР°СЃРЅРµС‚СЊ'], ['Ш§ЩђШµЩ’ЩЃЩЋШ±Щ‘ЩЋ / ЩЉЩЋШµЩ’ЩЃЩЋШ±Щ‘ЩЏ', 'Р¶РµР»С‚РµС‚СЊ']]],
    ['X', 'Ш§ЩђШіЩ’ШЄЩЋЩЃЩ’Ш№ЩЋЩ„ЩЋ / ЩЉЩЋШіЩ’ШЄЩЋЩЃЩ’Ш№ЩђЩ„ЩЏ', 'РџСЂРѕСЃСЊР±Р°, РїРѕРёСЃРє, СЃС‚СЂРµРјР»РµРЅРёРµ РёР»Рё РїРѕР»СѓС‡РµРЅРёРµ СЃРІРѕР№СЃС‚РІР°.', [['Ш§ЩђШіЩ’ШЄЩЋШ®Щ’Ш±ЩЋШ¬ЩЋ / ЩЉЩЋШіЩ’ШЄЩЋШ®Щ’Ш±ЩђШ¬ЩЏ', 'РёР·РІР»РµРєР°С‚СЊ'], ['Ш§ЩђШіЩ’ШЄЩЋШєЩ’ЩЃЩЋШ±ЩЋ / ЩЉЩЋШіЩ’ШЄЩЋШєЩ’ЩЃЩђШ±ЩЏ', 'РїСЂРѕСЃРёС‚СЊ РїСЂРѕС‰РµРЅРёСЏ']]]
  ];

  function esc(value) {
    return String(value == null ? '' : value).replace(/[&<>"']/g, function (char) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[char];
    });
  }
  function clean(value) { return String(value || '').replace(/[\u064B-\u065F\u0670]/g, ''); }
  function personRu(value) { return persons[value] || persons[clean(value)] || 'Р›РёС†Рѕ'; }
  function groupInfo(name) {
    var value = clean(name);
    if (value.includes('Ш§Щ„ШЈЩ…Ш±') && value.includes('Ш§Щ„Щ…Ш¤ЩѓШЇ')) return ['Ш§Щ„ШЈЩ…Ш± Ш§Щ„Щ…Ш¤ЩѓШЇ', 'РЈСЃРёР»РµРЅРЅРѕРµ РїРѕРІРµР»РёС‚РµР»СЊРЅРѕРµ'];
    if (value.includes('Ш§Щ„ШЈЩ…Ш±')) return ['Ш§Щ„ШЈЩ…Ш±', 'РџРѕРІРµР»РёС‚РµР»СЊРЅРѕРµ'];
    if (value.includes('Ш§Щ„Щ…Ш§Ш¶ЩЉ') && value.includes('Ш§Щ„Щ…Ш¬Щ‡Щ€Щ„')) return ['Ш§Щ„Щ…Ш§Ш¶ЩЉ Ш§Щ„Щ…Ш¬Щ‡Щ€Щ„', 'РџСЂРѕС€РµРґС€РµРµ, СЃС‚СЂР°РґР°С‚РµР»СЊРЅС‹Р№ Р·Р°Р»РѕРі'];
    if (value.includes('Ш§Щ„Щ…Ш§Ш¶ЩЉ')) return ['Ш§Щ„Щ…Ш§Ш¶ЩЉ Ш§Щ„Щ…Ш№Щ„Щ€Щ…', 'РџСЂРѕС€РµРґС€РµРµ, РґРµР№СЃС‚РІРёС‚РµР»СЊРЅС‹Р№ Р·Р°Р»РѕРі'];
    if (value.includes('Ш§Щ„Щ…Щ†ШµЩ€ШЁ')) return ['Ш§Щ„Щ…Ш¶Ш§Ш±Ш№ Ш§Щ„Щ…Щ†ШµЩ€ШЁ', 'РќР°СЃС‚РѕСЏС‰РµРµ, СЃРѕСЃР»Р°РіР°С‚РµР»СЊРЅРѕРµ'];
    if (value.includes('Ш§Щ„Щ…Ш¬ШІЩ€Щ…')) return ['Ш§Щ„Щ…Ш¶Ш§Ш±Ш№ Ш§Щ„Щ…Ш¬ШІЩ€Щ…', 'РќР°СЃС‚РѕСЏС‰РµРµ, СѓСЃРµС‡С‘РЅРЅРѕРµ'];
    if (value.includes('Ш§Щ„Щ…Ш¤ЩѓШЇ')) return ['Ш§Щ„Щ…Ш¶Ш§Ш±Ш№ Ш§Щ„Щ…Ш¤ЩѓШЇ', 'РќР°СЃС‚РѕСЏС‰РµРµ, СѓСЃРёР»РµРЅРЅРѕРµ'];
    if (value.includes('Ш§Щ„Щ…Ш¬Щ‡Щ€Щ„')) return ['Ш§Щ„Щ…Ш¶Ш§Ш±Ш№ Ш§Щ„Щ…Ш¬Щ‡Щ€Щ„', 'РќР°СЃС‚РѕСЏС‰РµРµ, СЃС‚СЂР°РґР°С‚РµР»СЊРЅС‹Р№ Р·Р°Р»РѕРі'];
    return ['Ш§Щ„Щ…Ш¶Ш§Ш±Ш№ Ш§Щ„Щ…Ш№Щ„Щ€Щ…', 'РќР°СЃС‚РѕСЏС‰РµРµ, РґРµР№СЃС‚РІРёС‚РµР»СЊРЅС‹Р№ Р·Р°Р»РѕРі'];
  }
  function matches(name) {
    var value = clean(name);
    if (state.tense === 'past' && !value.includes('Ш§Щ„Щ…Ш§Ш¶ЩЉ')) return false;
    if (state.tense === 'present' && !value.includes('Ш§Щ„Щ…Ш¶Ш§Ш±Ш№')) return false;
    if (state.tense === 'imperative' && !value.includes('Ш§Щ„ШЈЩ…Ш±')) return false;
    if (state.voice === 'active' && value.includes('Ш§Щ„Щ…Ш¬Щ‡Щ€Щ„')) return false;
    if (state.voice === 'passive' && !value.includes('Ш§Щ„Щ…Ш¬Щ‡Щ€Щ„')) return false;
    if (state.mood === 'plain' && (value.includes('Ш§Щ„Щ…Щ†ШµЩ€ШЁ') || value.includes('Ш§Щ„Щ…Ш¬ШІЩ€Щ…') || value.includes('Ш§Щ„Щ…Ш¤ЩѓШЇ'))) return false;
    if (state.mood === 'subjunctive' && !value.includes('Ш§Щ„Щ…Щ†ШµЩ€ШЁ')) return false;
    if (state.mood === 'jussive' && !value.includes('Ш§Щ„Щ…Ш¬ШІЩ€Щ…')) return false;
    if (state.mood === 'emphatic' && !value.includes('Ш§Щ„Щ…Ш¤ЩѓШЇ')) return false;
    return true;
  }
  function allGroups() {
    if (!state.forms) return [];
    var source = state.forms.all_forms || {};
    var groups = Object.keys(source).map(function (name) {
      var values = source[name] || {};
      return { name: name, rows: Object.keys(values).filter(function (key) { return values[key]; }).map(function (key) { return { pronoun: key, form: values[key] }; }) };
    }).filter(function (group) { return group.rows.length; });
    if (!groups.length) {
      [['Ш§Щ„Щ…Ш§Ш¶ЩЉ Ш§Щ„Щ…Ш№Щ„Щ€Щ…', state.forms.past], ['Ш§Щ„Щ…Ш¶Ш§Ш±Ш№ Ш§Щ„Щ…Ш№Щ„Щ€Щ…', state.forms.present], ['Ш§Щ„ШЈЩ…Ш±', state.forms.imperative]].forEach(function (entry) {
        var values = entry[1] || {};
        var rows = Object.keys(values).filter(function (key) { return values[key]; }).map(function (key) { return { pronoun: key, form: values[key] }; });
        if (rows.length) groups.push({ name: entry[0], rows: rows });
      });
    }
    return groups;
  }

  function visibleGroups() {
    return allGroups().filter(function (group) { return matches(group.name); });
  }

  function findFormGroup(kind, voice) {
    var groups = allGroups();
    return groups.filter(function (group) {
      var name = clean(group.name);
      var wantedVoice = voice === 'passive' ? name.includes('Ш§Щ„Щ…Ш¬Щ‡Щ€Щ„') : !name.includes('Ш§Щ„Щ…Ш¬Щ‡Щ€Щ„');
      if (!wantedVoice) return false;
      if (kind === 'past') return name.includes('Ш§Щ„Щ…Ш§Ш¶ЩЉ');
      if (kind === 'present') return name.includes('Ш§Щ„Щ…Ш¶Ш§Ш±Ш№') && !name.includes('Ш§Щ„Щ…Щ†ШµЩ€ШЁ') && !name.includes('Ш§Щ„Щ…Ш¬ШІЩ€Щ…') && !name.includes('Ш§Щ„Щ…Ш¤ЩѓШЇ');
      return name.includes('Ш§Щ„ШЈЩ…Ш±') && !name.includes('Ш§Щ„Щ…Ш¤ЩѓШЇ');
    })[0] || { rows: [] };
  }

  function formFor(group, pronoun) {
    return (group.rows || []).filter(function (row) { return row.pronoun === pronoun; })[0]?.form || 'вЂ”';
  }

  function generalTable() {
    var past = findFormGroup('past', state.voice);
    var present = findFormGroup('present', state.voice);
    var imperative = state.voice === 'active' ? findFormGroup('imperative', 'active') : { rows: [] };
    var personRows = past.rows.length ? past.rows : present.rows;
    if (!personRows.length) return '<div class="vs-empty">Р”Р»СЏ РІС‹Р±СЂР°РЅРЅРѕРіРѕ Р·Р°Р»РѕРіР° Qutrub РЅРµ РІРµСЂРЅСѓР» Р±Р°Р·РѕРІС‹Рµ С„РѕСЂРјС‹.</div>';
    return '<section class="vs-result-group vs-general-table"><div class="vs-group-heading"><div><h3>РћР±С‰Р°СЏ С‚Р°Р±Р»РёС†Р°</h3><p>РџСЂРѕС€РµРґС€РµРµ, РЅР°СЃС‚РѕСЏС‰РµРµ Рё РїРѕРІРµР»РёС‚РµР»СЊРЅРѕРµ РІ РѕРґРЅРѕР№ СЃС‚СЂРѕРєРµ.</p></div><span dir="rtl">Ш§Щ„Щ…Ш§Ш¶ЩЉ В· Ш§Щ„Щ…Ш¶Ш§Ш±Ш№ В· Ш§Щ„ШЈЩ…Ш±</span></div><div class="vs-table-wrap"><table class="vs-table"><thead><tr><th>Р›РёС†Рѕ</th><th>РџРµСЂРµРІРѕРґ</th><th>Р¤РѕСЂРјС‹</th></tr></thead><tbody>' +
      personRows.map(function (row) {
        return '<tr><td class="vs-pronoun" dir="rtl">' + esc(row.pronoun) + '</td><td class="vs-person-ru">' + esc(personRu(row.pronoun)) + '</td><td class="vs-general-forms" dir="rtl"><div><small>Ш§Щ„Щ…Ш§Ш¶ЩЉ</small><b>' + esc(formFor(past, row.pronoun)) + '</b></div><div><small>Ш§Щ„Щ…Ш¶Ш§Ш±Ш№</small><b>' + esc(formFor(present, row.pronoun)) + '</b></div><div><small>Ш§Щ„ШЈЩ…Ш±</small><b>' + esc(formFor(imperative, row.pronoun)) + '</b></div></td></tr>';
      }).join('') + '</tbody></table></div></section>';
  }
  function renderGroup(group) {
    var title = groupInfo(group.name);
    var content = state.layout === 'table'
      ? '<div class="vs-table-wrap"><table class="vs-table"><thead><tr><th>Р›РёС†Рѕ</th><th>РџРµСЂРµРІРѕРґ</th><th>Р¤РѕСЂРјР°</th></tr></thead><tbody>' + group.rows.map(function (row) {
          return '<tr><td class="vs-pronoun" dir="rtl">' + esc(row.pronoun) + '</td><td class="vs-person-ru">' + esc(personRu(row.pronoun)) + '</td><td class="vs-result-form" dir="rtl">' + esc(row.form) + '</td></tr>';
        }).join('') + '</tbody></table></div>'
      : '<div class="vs-form-list">' + group.rows.map(function (row) {
          return '<div class="vs-form-row"><div><div class="vs-pronoun" dir="rtl">' + esc(row.pronoun) + '</div><small>' + esc(personRu(row.pronoun)) + '</small></div><div class="vs-result-form" dir="rtl">' + esc(row.form) + '</div></div>';
        }).join('') + '</div>';
    return '<section class="vs-result-group"><div class="vs-group-heading"><h3 dir="rtl">' + esc(title[0]) + '</h3><p>' + esc(title[1]) + '</p></div>' + content + '</section>';
  }
  function conjugationModal() {
    var groups = visibleGroups();
    var resultHtml = state.tableMode === 'general' ? generalTable() : (groups.length ? groups.map(renderGroup).join('') : '<div class="vs-empty">Для выбранных параметров Qutrub не вернул формы глагола.</div>');
    return '<div class="vs-modal" role="dialog" aria-modal="true"><div class="vs-modal-sheet"><header class="vs-modal-head"><div><p class="vs-eyebrow">РЎРїСЂСЏР¶РµРЅРёСЏ РіР»Р°РіРѕР»Р°</p><h2 class="vs-modal-verb" dir="rtl">' + esc(state.verb) + '</h2></div><button class="vs-icon-button" data-action="close">Г—</button></header>' +
      '<section class="vs-result-workspace '+(state.tableMode === 'general' ? 'is-general' : '')+'"><div class="vs-table-kind"><button class="vs-kind-button '+(state.tableMode === 'single' ? 'active' : '')+'" data-table-mode="single">Обычная</button><button class="vs-kind-button '+(state.tableMode === 'general' ? 'active' : '')+'" data-table-mode="general">Общая таблица</button></div><div class="vs-result-workspace-head"><div><h3>Р¤РѕСЂРјС‹ РіР»Р°РіРѕР»Р°</h3><p>Р’С‹Р±РµСЂРёС‚Рµ РЅСѓР¶РЅС‹Рµ РїР°СЂР°РјРµС‚СЂС‹ РїСЂСЏРјРѕ Р·РґРµСЃСЊ.</p></div><div class="vs-view-switch"><button class="vs-view-button ' + (state.layout === 'list' ? 'active' : '') + '" data-layout="list">РЎРїРёСЃРѕРє</button><button class="vs-view-button ' + (state.layout === 'table' ? 'active' : '') + '" data-layout="table">РўР°Р±Р»РёС†Р°</button></div></div>' +
      '<div class="vs-table-controls"><div class="vs-control-row"><span>Р’СЂРµРјСЏ</span><div><button class="vs-filter ' + (state.tense === 'all' ? 'active' : '') + '" data-filter="tense" data-value="all">Р’СЃРµ</button><button class="vs-filter ' + (state.tense === 'past' ? 'active' : '') + '" data-filter="tense" data-value="past">Ш§Щ„Щ…Ш§Ш¶ЩЉ</button><button class="vs-filter ' + (state.tense === 'present' ? 'active' : '') + '" data-filter="tense" data-value="present">Ш§Щ„Щ…Ш¶Ш§Ш±Ш№</button><button class="vs-filter ' + (state.tense === 'imperative' ? 'active' : '') + '" data-filter="tense" data-value="imperative">Ш§Щ„ШЈЩ…Ш±</button></div></div>' +
      '<div class="vs-control-row"><span>Р—Р°Р»РѕРі</span><div><button class="vs-filter ' + (state.voice === 'all' ? 'active' : '') + '" data-filter="voice" data-value="all">Р’СЃРµ</button><button class="vs-filter ' + (state.voice === 'active' ? 'active' : '') + '" data-filter="voice" data-value="active">Р”РµР№СЃС‚РІРёС‚РµР»СЊРЅС‹Р№</button><button class="vs-filter ' + (state.voice === 'passive' ? 'active' : '') + '" data-filter="voice" data-value="passive">РЎС‚СЂР°РґР°С‚РµР»СЊРЅС‹Р№</button></div></div>' +
      '<div class="vs-control-row"><span>РќР°РєР»РѕРЅРµРЅРёРµ</span><div><button class="vs-filter ' + (state.mood === 'all' ? 'active' : '') + '" data-filter="mood" data-value="all">Р’СЃРµ</button><button class="vs-filter ' + (state.mood === 'plain' ? 'active' : '') + '" data-filter="mood" data-value="plain">РћР±С‹С‡РЅРѕРµ</button><button class="vs-filter ' + (state.mood === 'subjunctive' ? 'active' : '') + '" data-filter="mood" data-value="subjunctive">Щ…Щ†ШµЩ€ШЁ</button><button class="vs-filter ' + (state.mood === 'jussive' ? 'active' : '') + '" data-filter="mood" data-value="jussive">Щ…Ш¬ШІЩ€Щ…</button><button class="vs-filter ' + (state.mood === 'emphatic' ? 'active' : '') + '" data-filter="mood" data-value="emphatic">Щ…Ш¤ЩѓШЇ</button></div></div></div>' +
      '<div class="vs-help vs-inline-help"><strong>РџРѕРґСЃРєР°Р·РєР°</strong><span>Р¤РёР»СЊС‚СЂС‹ РІР»РёСЏСЋС‚ С‚РѕР»СЊРєРѕ РЅР° РїРѕРєР°Р· С„РѕСЂРј РЅРёР¶Рµ: РёС… РјРѕР¶РЅРѕ РјРµРЅСЏС‚СЊ РІ Р»СЋР±РѕР№ РјРѕРјРµРЅС‚ Р±РµР· РЅРѕРІРѕРіРѕ Р·Р°РїСЂРѕСЃР°.</span></div><div class="vs-results">' + (groups.length ? groups.map(renderGroup).join('') : '<div class="vs-empty">Р”Р»СЏ РІС‹Р±СЂР°РЅРЅС‹С… РїР°СЂР°РјРµС‚СЂРѕРІ Qutrub РЅРµ РІРµСЂРЅСѓР» С„РѕСЂРјС‹ РіР»Р°РіРѕР»Р°.</div>') + '</div></section></div></div>';
  }
  function patternsMatrix() {
    var rows = [
      ['I','فَعَلَ','يَفْعَلُ','فَاعِل','مَفْعُول','فُعِلَ','يُفْعَلُ','مَصْدَرٌ مُتَنَوِّع','اِفْعَلْ','لَا تَفْعَلْ'],
      ['II','فَعَّلَ','يُفَعِّلُ','مُفَعِّل','مُفَعَّل','فُعِّلَ','يُفَعَّلُ','تَفْعِيل','فَعِّلْ','لَا تُفَعِّلْ'],
      ['III','فَاعَلَ','يُفَاعِلُ','مُفَاعِل','مُفَاعَل','فُوعِلَ','يُفَاعَلُ','مُفَاعَلَة','فَاعِلْ','لَا تُفَاعِلْ'],
      ['IV','أَفْعَلَ','يُفْعِلُ','مُفْعِل','مُفْعَل','أُفْعِلَ','يُفْعَلُ','إِفْعَال','أَفْعِلْ','لَا تُفْعِلْ'],
      ['V','تَفَعَّلَ','يَتَفَعَّلُ','مُتَفَعِّل','مُتَفَعَّل','تُفُعِّلَ','يُتَفَعَّلُ','تَفَعُّل','تَفَعَّلْ','لَا تَتَفَعَّلْ'],
      ['VI','تَفَاعَلَ','يَتَفَاعَلُ','مُتَفَاعِل','مُتَفَاعَل','تُفُوعِلَ','يُتَفَاعَلُ','تَفَاعُل','تَفَاعَلْ','لَا تَتَفَاعَلْ'],
      ['VII','اِنْفَعَلَ','يَنْفَعِلُ','مُنْفَعِل','—','اُنْفُعِلَ','يُنْفَعَلُ','اِنْفِعَال','اِنْفَعِلْ','لَا تَنْفَعِلْ'],
      ['VIII','اِفْتَعَلَ','يَفْتَعِلُ','مُفْتَعِل','مُفْتَعَل','اُفْتُعِلَ','يُفْتَعَلُ','اِفْتِعَال','اِفْتَعِلْ','لَا تَفْتَعِلْ'],
      ['IX','اِفْعَلَّ','يَفْعَلُّ','مُفْعَلّ','—','—','—','اِفْعِلَال','—','—'],
      ['X','اِسْتَفْعَلَ','يَسْتَفْعِلُ','مُسْتَفْعِل','مُسْتَفْعَل','اُسْتُفْعِلَ','يُسْتَفْعَلُ','اِسْتِفْعَال','اِسْتَفْعِلْ','لَا تَسْتَفْعِلْ']
    ];
    var headings = ['Порода|الوزن','Прошедшее|الماضي','Настоящее|المضارع','Действ. причастие|اسم الفاعل','Страд. причастие|اسم المفعول','Страд. прошедшее|الماضي للمجهول','Страд. настоящее|المضارع للمجهول','Масдар|المصدر','Повелительное|الأمر','Запрет|النهي'];
    return '<section class="vs-pattern-matrix"><h3>Общая таблица пород</h3><p>Формулы для ориентира. У I породы масдар и гласная настоящего времени уточняются по словарю.</p><div class="vs-pattern-matrix-wrap"><table><thead><tr>' + headings.map(function (heading) { var parts = heading.split('|'); return '<th><span>' + parts[0] + '</span><b dir="rtl">' + parts[1] + '</b></th>'; }).join('') + '</tr></thead><tbody>' + rows.map(function (row) { return '<tr>' + row.map(function (cell, index) { return '<td class="' + (index === 0 ? 'vs-pattern-number' : '') + '" dir="' + (index ? 'rtl' : 'ltr') + '">' + cell + '</td>'; }).join('') + '</tr>'; }).join('') + '</tbody></table></div></section>';
  }
  function patternsModal() {
    return '<div class="vs-modal" role="dialog" aria-modal="true"><div class="vs-modal-sheet"><header class="vs-modal-head"><div><p class="vs-eyebrow">РљСЂР°С‚РєР°СЏ СЃРїСЂР°РІРєР°</p><h2>РџРѕСЂРѕРґС‹ РіР»Р°РіРѕР»РѕРІ вЂ” Ш§Щ„ШЈЩ€ШІШ§Щ†</h2></div><button class="vs-icon-button" data-action="close">Г—</button></header><div class="vs-help"><strong>РљР°Рє С‡РёС‚Р°С‚СЊ С„РѕСЂРјСѓР»Сѓ</strong><span>ЩЃ вЂ” РїРµСЂРІР°СЏ Р±СѓРєРІР° РєРѕСЂРЅСЏ, Ш№ вЂ” РІС‚РѕСЂР°СЏ, Щ„ вЂ” С‚СЂРµС‚СЊСЏ. Р¤РѕСЂРјСѓР»Р° РїРѕРєР°Р·С‹РІР°РµС‚ СЃС‚СЂРѕРµРЅРёРµ РїРѕСЂРѕРґС‹, Р° РЅРµ РїРµСЂРµРІРѕРґ РєРѕРЅРєСЂРµС‚РЅРѕРіРѕ СЃР»РѕРІР°.</span></div><div class="vs-pattern-list">' + patterns.map(function (item) {
      return '<article class="vs-pattern-card"><div class="vs-pattern-top"><b>РџРѕСЂРѕРґР° ' + item[0] + '</b><strong dir="rtl">' + item[1] + '</strong></div><p>' + item[2] + '</p><div class="vs-pattern-examples">' + item[3].map(function (example) {
        return '<div><span dir="rtl">' + example[0] + '</span><small>' + example[1] + '</small></div>';
      }).join('') + '</div></article>';
    }).join('') + '</div>' + patternsMatrix() + '</div></div>';
  }
  function render() {
    var root = document.getElementById(rootId);
    if (!root) return;
    root.innerHTML = '<main class="vs-page"><header class="vs-head"><button class="vs-back" data-action="back">вЂ№</button><div><h1>РЎРїСЂСЏР¶РµРЅРёРµ РіР»Р°РіРѕР»РѕРІ</h1><p class="vs-sub">Р¤СѓСЃС…Р°: С„РѕСЂРјС‹ СЃС‚СЂРѕСЏС‚СЃСЏ РїРѕ РїСЂР°РІРёР»Р°Рј Qutrub.</p></div></header><section class="vs-card"><label class="vs-label" for="vs-input">Р“Р»Р°РіРѕР» РІ РїСЂРѕС€РµРґС€РµРј РІСЂРµРјРµРЅРё</label><div class="vs-search"><input id="vs-input" class="vs-input" value="' + esc(state.verb) + '" placeholder="ЩѓЩЋШЄЩЋШЁЩЋ" dir="rtl" autocomplete="off"><button class="vs-primary" data-action="conjugate" ' + (state.loading ? 'disabled' : '') + '>' + (state.loading ? 'РЎС‚СЂРѕРёРјвЂ¦' : 'РЎРїСЂСЏРіР°С‚СЊ') + '</button></div><p class="vs-tip">РџРѕСЃР»Рµ РЅР°Р¶Р°С‚РёСЏ РѕС‚РєСЂРѕСЋС‚СЃСЏ РІСЃРµ С„РѕСЂРјС‹ СЃ СЂСѓСЃСЃРєРёРј РїРµСЂРµРІРѕРґРѕРј Р»РёС†. Р’РЅСѓС‚СЂРё РјРѕР¶РЅРѕ РІС‹Р±СЂР°С‚СЊ РІСЂРµРјСЏ, Р·Р°Р»РѕРі, РЅР°РєР»РѕРЅРµРЅРёРµ Рё РІРёРґ.</p></section><section class="vs-card vs-pattern-entry"><div><p class="vs-eyebrow">РЎРїСЂР°РІРєР°</p><h2>РџРѕСЂРѕРґС‹ РіР»Р°РіРѕР»РѕРІ</h2><p class="vs-copy">10 РјРѕРґРµР»РµР№ С„СѓСЃС…Р°: С„РѕСЂРјСѓР»Р°, РѕР±СЉСЏСЃРЅРµРЅРёРµ Рё РґРІР° РїСЂРёРјРµСЂР° СЃ РїРµСЂРµРІРѕРґРѕРј.</p></div><button class="vs-action" data-action="patterns">РћС‚РєСЂС‹С‚СЊ РїРѕСЂРѕРґС‹</button></section></main>' + (state.modal === 'conjugations' ? conjugationModal() : state.modal === 'patterns' ? patternsModal() : '');
    root.querySelectorAll('[data-action]').forEach(function (button) { button.onclick = function () {
      var action = button.dataset.action;
      if (action === 'back') {
        if (window.appNavigateBack) window.appNavigateBack('screen-course');
        else if (window.showScreen) window.showScreen('screen-course');
      }
      if (action === 'conjugate') conjugate();
      if (action === 'patterns') { state.modal = 'patterns'; render(); }
      if (action === 'close') { state.modal = ''; render(); }
    }; });
    root.querySelectorAll('[data-layout]').forEach(function (button) { button.onclick = function () { state.layout = button.dataset.layout; render(); }; });
    root.querySelectorAll('[data-table-mode]').forEach(function (button) { button.onclick = function () { state.tableMode = button.dataset.tableMode; render(); }; });
    root.querySelectorAll('[data-filter]').forEach(function (button) {
      button.onclick = function () {
        state[button.dataset.filter] = button.dataset.value;
        render();
      };
    });
    var input = root.querySelector('#vs-input');
    if (input) input.onkeydown = function (event) { if (event.key === 'Enter') conjugate(); };
  }
  function conjugate() {
    var input = document.getElementById('vs-input');
    state.verb = (input ? input.value : state.verb).trim();
    if (!state.verb) { state.error = 'Р’РІРµРґРёС‚Рµ Р°СЂР°Р±СЃРєРёР№ РіР»Р°РіРѕР».'; render(); return; }
    state.loading = true; state.error = ''; state.modal = ''; render();
    fetch(endpoint + '?verb=' + encodeURIComponent(state.verb), { headers: { Accept: 'application/json' } })
      .then(function (response) { if (!response.ok) throw new Error('Qutrub РІСЂРµРјРµРЅРЅРѕ РЅРµРґРѕСЃС‚СѓРїРµРЅ.'); return response.json(); })
      .then(function (data) {
        if (!data || !data.ok || !data.forms) throw new Error('РќРµ СѓРґР°Р»РѕСЃСЊ РїРѕСЃС‚СЂРѕРёС‚СЊ С„РѕСЂРјС‹ СЌС‚РѕРіРѕ РіР»Р°РіРѕР»Р°.');
        state.forms = data.forms; state.verb = data.verb || state.verb; state.tableMode = 'single'; state.tense = 'past'; state.voice = 'active'; state.mood = 'plain'; state.layout = 'table'; state.modal = 'conjugations';
      })
      .catch(function (error) { state.forms = null; state.error = error.message || 'РќРµ СѓРґР°Р»РѕСЃСЊ РїРѕСЃС‚СЂРѕРёС‚СЊ СЃРїСЂСЏР¶РµРЅРёРµ.'; })
      .finally(function () { state.loading = false; render(); });
  }
  window.openVerbStudy = function () { if (window.showScreen) window.showScreen(rootId); render(); };
}());
