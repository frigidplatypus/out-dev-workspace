title:: Query Fences

- Every open task in the workspace: status: todo keeps blocks with the TODO prefix, and checkbox [ ] counts as the same state; sort: page groups the hits by their page.
- ```query
  status: todo
  sort: page
  ```
  - > **result:** (6 blocks)
    - !((blk-bqw0yj))
    - !((blk-h8exgh))
    - !((blk-zjvzv3))
    - !((blk-p20h71))
    - !((blk-8nsrfr))
    - !((blk-eg4dc5))
- EXPECT: every TODO-spelled block, sorted by page; checkbox [ ] blocks join them, [/] and [x] do not.
- All task states in one list: status: open covers todo, doing and done; sort: status ranks them todo first, doing next, done last.
- ```query
  status: open
  sort: status
  ```
  - > **result:** (12 blocks)
    - !((blk-h8exgh))
    - !((blk-bqw0yj))
    - !((blk-eg4dc5))
    - !((blk-zjvzv3))
    - !((blk-p20h71))
    - !((blk-8nsrfr))
    - !((blk-4g72a2))
    - !((blk-v8rjaj))
    - !((blk-g54h9j))
    - !((blk-s9k280))
    - !((blk-md7g85))
    - !((blk-mxkwa9))
- EXPECT: every task in every state; todo rank first, doing next, done last.
- Comma inside a tag value: the tag alphabet is letters, digits, dash, underscore and slash only, so the comma is a parse error, not a union. Unions over tags are spelled as repeated tag: lines, as the next fence shows.
- ```query
  tag: rebel, jedi
  sort: page
  ```
  - > **result:** `error: line 1: tag 'rebel, jedi' contains ',', which cannot appear in a tag (letters, digits, '-', '_' and '/' only)`
- EXPECT: line 1 error — tag contains a comma, which cannot appear in a tag (letters, digits, dash, underscore and slash only).
- Two filters on one key AND: a block survives only if it carries both #tatooine and #rebel. Repeated lines exclude more, they do not widen.
- ```query
  tag: tatooine
  tag: rebel
  sort: page
  ```
  - > **result:** (2 blocks)
    - !((blk-6j599y))
    - !((blk-1kpw1r))
- EXPECT: two hits - Rally point carries both #tatooine and #rebel; this comment also answers because prose naming both tags counts as carrying them. Repeated lines AND, they do not widen.EXPECT: two hits - Rally point carries both #tatooine and #rebel; this comment also answers because prose naming both tags counts as carrying them. Repeated lines AND, they do not widen.
- Boundary match plus negation: keep blocks tagged #rebel, drop the ones also tagged #alliance. Matching stops at the tag boundary, so #rebellion is not matched by either side.
- ```query
  tag: rebel
  not-tag: alliance
  ```
  - > **result:** (8 blocks)
    - !((blk-6j599y))
    - !((blk-4g72a2))
    - !((blk-v8rjaj))
    - !((blk-mxkwa9))
    - !((blk-na1cdg))
    - !((blk-bt6pv2))
    - !((blk-1kpw1r))
    - !((blk-8nsrfr))
- EXPECT: eight hits - plain #rebel blocks plus the nested #rebel/alliance block, whose slash segment is not a standalone tag so not-tag: alliance keeps it; this comment and this EXPECT answer through their prose mentions; #rebellion stays out.EXPECT: eight hits - plain #rebel blocks plus the nested #rebel/alliance block, whose slash segment is not a standalone tag so not-tag: alliance keeps it; this comment and this EXPECT answer through their prose mentions; #rebellion stays out.
- Negation combined with a state filter and windowing: todo blocks that do not carry #jedi, ordered by text, cut to the first three.
- ```query
  not-tag: jedi
  status: todo
  sort: text
  limit: 3
  ```
  - > **result:** (3 blocks)
    - !((blk-eg4dc5))
    - !((blk-h8exgh))
    - !((blk-8nsrfr))
- EXPECT: todo blocks without #jedi, byte-ordered, capped at three: Chase the Rancor in the pit, Deploy the probe droids, Rescue Han from carbonite.
- Property presence and value: prop: due keeps blocks carrying a due:: property, and the :: value narrows it to one exact date. The double-colon spelling matches how properties are written in the .md.
- ```query
  prop: due:: 2026-02-15
  sort: page
  ```
  - > **result:** (1 blocks)
    - !((blk-p20h71))
- EXPECT: Train at the Jedi temple — the only block carrying due:: 2026-02-15.
- Journal window: kind: journal restricts to journal pages, since: 7d keeps entries dated inside the last seven days. Ordinary pages are not journals, so they never answer this fence.
- ```query
  kind: journal
  since: 7d
  sort: page
  ```
  - > **result:** (7 blocks)
    - !((blk-ms7pj3))
    - !((blk-bqw0yj))
    - !((blk-647ndt))
    - !((blk-bt6pv2))
    - !((blk-hn5gmc))
    - !((blk-qqpgca))
    - !((blk-9sm7gt))
- EXPECT: seven hits - every block of the today, minus-1d and minus-3d journals, counting the empty filler blocks and the [[q-fences]] ref line; the minus-30d survey falls outside the window.EXPECT: seven hits - every block of the today, minus-1d and minus-3d journals, counting the empty filler blocks and the [[q-fences]] ref line; the minus-30d survey falls outside the window.
- Substring search narrowed by state: text: garrison is case-insensitive over block text, status: done keeps only completed tasks.
- ```query
  text: garrison
  status: done
  ```
  - > **result:** (1 blocks)
    - !((blk-s9k280))
- EXPECT: Audit the garrison logs only — substring is case-insensitive, status narrows to done.
- Case-insensitive value: a capitalized tag value matches both spellings of the tag name, while the directive key itself stays lowercase.
- ```query
  tag: Jedi
  sort: page
  ```
  - > **result:** (7 blocks)
    - !((blk-bqw0yj))
    - !((blk-mmm8nm))
    - !((blk-tnr9mf))
    - !((blk-20c24r))
    - !((blk-z8j6pb))
    - !((blk-zjvzv3))
    - !((blk-p20h71))
- EXPECT: seven hits - Train, Meet Yoda, Upper case notes, Refit, plus this EXPECT and the two comments above that mention jedi tags in prose; the value matches #jedi and #Jedi alike.EXPECT: seven hits - Train, Meet Yoda, Upper case notes, Refit, plus this EXPECT and the two comments above that mention jedi tags in prose; the value matches #jedi and #Jedi alike.
- Positive and its exact negation on the same key: both lines must hold, so nothing can. Useful for confirming the complement is real.
- ```query
  status: open
  not-status: open
  ```
  - > **result:** (0 blocks)
- EXPECT: empty — a positive and its exact negation can never both hold, for every key.
- Controls have no negative: sort and limit are not filters, so the not- wrapper is rejected as an unknown key rather than silently ignored.
- ```query
  not-sort: page
  ```
  - > **result:** `error: line 1: unknown key: 'not-sort'`
- EXPECT: parse error on line 1 — sort is not a filter, so not-sort is an unknown key.
