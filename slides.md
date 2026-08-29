---
title: "LLM Beliefs Are in Their Heads / Thinking Out Loud"
description: >-
  第18回最先端NLP研究会(2026) 発表資料: LLM Beliefs Are in Their Heads / Thinking Out Loud
lang: ja
---

<!--
Build with: sh scripts/build.sh
Use Pandoc fenced divs for layout, e.g. ::: {.screen} ... :::
Keep complex SVG diagrams as raw HTML blocks fenced with ```{=html}.
-->

```{=html}
<section class="screen center title-biblio-slide">
  <style>
    .title-biblio-slide .title-stack {
      width: min(100%, 1120px);
      gap: 22px;
    }
    .title-biblio-slide .title-paper-list {
      display: grid;
      gap: 16px;
      margin: 0;
      padding: 0;
      list-style: none;
      text-align: left;
    }
    .title-biblio-slide .title-paper-item {
      display: grid;
      gap: 5px;
      margin: 0;
      border-top: 1px solid var(--line);
      padding-top: 16px;
      line-height: 1.3;
    }
    .title-biblio-slide .title-paper-item:first-child {
      border-top: 0;
      padding-top: 0;
    }
    .title-biblio-slide .title-paper-id {
      display: block;
      color: var(--muted);
      font-size: 1.05rem;
      font-weight: 650;
      letter-spacing: 0;
      line-height: 1.35;
    }
    .title-biblio-slide .title-paper-name {
      display: block;
      color: var(--ink);
      font-size: 2rem;
      font-weight: 760;
      line-height: 1.18;
    }
    .title-biblio-slide .title-paper-authors {
      display: block;
      color: var(--muted);
      font-size: 1.05rem;
      font-weight: 500;
      line-height: 1.4;
    }
    .title-biblio-slide .title-draft-note {
      margin: 0;
      color: var(--muted);
      font-size: 1.12rem;
      font-weight: 600;
      line-height: 1.5;
    }
    .title-biblio-slide .title-subtitle {
      margin: 0;
      color: var(--ink);
      font-size: clamp(1.42rem, 2.4vw, 2rem);
      font-weight: 720;
      line-height: 1.35;
    }
  </style>
  <p class="kicker">第18回最先端NLP研究会(2026)</p>
  <div class="title-stack" aria-label="発表で扱う2本の論文">
    <ul class="title-paper-list">
    <li class="title-paper-item">
      <span class="title-paper-id">1本目: 2026.acl-long.1905 (ACL2026)</span>
      <span class="title-paper-name">LLM Beliefs Are in Their Heads</span>
      <span class="title-paper-authors">Alessandro Corona Mendozza, Anders Søgaard</span>
    </li>
    <li class="title-paper-item">
      <span class="title-paper-id">2本目: 2025.emnlp-main.73 (EMNLP2025)</span>
      <span class="title-paper-name">Thinking Out Loud: Do Reasoning Models Know When They’re Right?</span>
      <span class="title-paper-authors">Qingcheng Zeng, Weihao Xuan, Leyang Cui, Rob Voigt</span>
    </li>
    </ul>
    <p class="title-draft-note">（まだ作成中です）</p>
  </div>
  <p class="title-subtitle">LLMが「知っている」ってどういう状態？</p>
  <p class="byline">亀田尭宙（人間文化研究機構）</p>
</section>
```

:::: {.section .screen}
## まず問いを分ける

同じ “Paris is in France” についても、少なくとも次の6種類は別の問いである。

```{=html}
<style>
  .epistemic-notions-table .out-of-scope-row td {
    background: #e1e5e3;
    color: #74807c;
  }
  .epistemic-notions-table .out-of-scope-row strong {
    color: #5f6c68;
  }
</style>
<div class="compact-table data-table epistemic-notions-table">
  <table>
    <thead>
      <tr>
        <th>概念</th>
        <th>問い</th>
        <th>Paris の例</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><strong>Fact / Truth</strong></td>
        <td><strong>外部の基準では真か？</strong></td>
        <td>ground truth では “Paris is in France.” は True</td>
      </tr>
      <tr>
        <td><strong>Encoded information / Representation</strong></td>
        <td><strong>その情報が内部に表象されているか？</strong></td>
        <td>Paris → France に対応する情報を activation から decode できる</td>
      </tr>
      <tr>
        <td><strong>Belief-like state</strong></td>
        <td><strong>モデルはそれを真として扱っているか？</strong></td>
        <td>Paris が France にあることを、真であるものとして判断する</td>
      </tr>
      <tr class="out-of-scope-row">
        <td><strong>Background commitment / Inferential role</strong></td>
        <td><strong>それを明示せず、他の推論の前提として利用するか？</strong></td>
        <td>「Louvre は Paris にある」から「Louvre は France にある」と推論する際に Paris → France を前提として使う</td>
      </tr>
      <tr>
        <td><strong>Confidence / Metacognition</strong></td>
        <td><strong>自分の判断が正しいと、どれくらい見積もるか？</strong></td>
        <td>「Paris は France にある」という自分の判断に 90% の確信を示す</td>
      </tr>
      <tr>
        <td><strong>Assertion / Verbal output</strong></td>
        <td><strong>実際に何を外部へ表出するか？</strong></td>
        <td>“Paris is in France.” と生成する</td>
      </tr>
    </tbody>
  </table>
</div>
```

::: quote
**Truth ≠ Representation ≠ Belief ≠ Confidence ≠ Output**
:::
::::

:::::::: {.section .screen}
::: kicker
Two Papers
:::

## 2本は地図の別々の場所を扱う

::: {.compact-table .data-table}
| 対象 ↓ / 現れ方 → | 内部表象 | 外部への表出・出力 |
|---|---|---|
| **事実についての情報** | **Beliefs: Accuracy** — 外部の True/False と対応する情報を probe | **Thinking Out Loud** — factual task での正答・誤答 / `I don't know` |
| **信念に類するもの** | **Beliefs: Coherence / Uniformity** — belief-like な整合性・一般性 | **Beliefs: Use** — steering → 真偽判断の変化 |
| **確信・メタ認知** | — | **Thinking Out Loud** — verbalized confidence / calibration |
:::

::: note
同じ「知っている」に見えるものでも、内部に表現される情報、真として扱う状態、外に出る回答や confidence は別の観測対象である。今回の焦点は、内部状態が answer / verbalized confidence / abstention としてどの程度 faithful に表出されるかにある。
:::
::::::::

::::::::: {.section .screen}
::: kicker
Paper 1
:::

## LLM Beliefs Are in Their Heads

::: lead
内部に decode 可能な truth-sensitive representation があるとして、それを belief-like state と呼ぶには何を追加で確かめるべきかを問う。
:::

:::::: three-col
::: panel
**強い点**

truth-sensitive な中間表現が、大きめの Llama / Gemma 系モデルでかなり高精度に読める。さらに、見つけた方向へ activation を動かすと True / False 出力も変わるため、単なる相関特徴ではなく計算に使われている可能性がある。
:::

::: panel
**注目点**

residual stream 全体だけでなく、一部の attention head output にも truth signal が局所的に現れる。head-level の signal は場所が限られるぶん、steering したときに小さい介入でも出力へ効きやすい。
:::

::: panel
**弱い点**

Accuracy と Use は強いが、Coherence は中程度に留まる。特に negation や論理的 paraphrase では崩れやすく、truth-sensitive representation をそのまま安定した「信念」と読むには慎重さが必要になる。
:::
::::::
::::::::: 

::::: {.section .flow}
::: kicker
Paper 1 / Terms
:::

## 4基準は「信念らしさ」の別々の条件

この論文の Accuracy / Use / Coherence / Uniformity は、通常のモデル評価指標というより、 内部表現が belief-like と言えるための条件として使われている。日本語では次のように読むと説明しやすい。

  英語         日本語での読み                      何を問うか                                                                                実験での見方
  ------------ ----------------------------------- ----------------------------------------------------------------------------------------- -----------------------------------------------------------------------------------------------------
  Accuracy     真偽分離性 / 分離精度「読めるか」               内部表現が true input と false input を分けているか。                                     最終トークン位置の内部ベクトルや attention head の出力から、ロジスティック回帰で真偽を当てる。
  Use          機能的使用 / 出力への関与 「使われているか」          読める truth signal が、実際にモデルの出力計算に使われているか。                          真偽を分ける方向へ内部ベクトルを少し動かし、True/False の出力確率が変わるかを見る。
  Coherence    整合性「矛盾しないか」                              p, not-p, p and q, p or q などの論理関係に対して一貫するか。                              否定・言い換え・連言・選言で真偽判定が崩れないか、疑似確率が基本的な確率制約を満たすかを見る。
  Uniformity   ドメイン一貫性「別領域にも通用するか」   都市・企業・数比較・翻訳など、異なる domain でも同じような truth direction が使えるか。   ある領域で作った真偽判定の手がかりが、別領域の真偽文にも通用するかを見る。

:::::

```{=html}
<section class="screen">
        <p class="kicker">Transformer Refresher 1</p>
        <h2>residual stream は、層をまたぐ共有の通路</h2>
        <p>
          ある1つの layer 出力時点で見る residual stream の形は
          <span class="shape-note">入力 token 数 x d_model</span>。
          <span class="shape-note">d_model</span> は token embedding の埋込次元数で、それらが layer ごとになっているので全体ではさらに <span class="shape-note">x layer 数</span>
        </p>
        <div class="diagram-block">
          <svg class="diagram-svg" viewBox="0 0 960 530" role="img" aria-labelledby="residual-title residual-desc">
            <title id="residual-title">Residual stream as a shared communication channel</title>
            <desc id="residual-desc">
              Token embeddings enter a residual stream. Each transformer layer reads from the stream, computes attention
              and MLP updates, and writes the updates back by addition.
            </desc>
            <text x="58" y="52" class="label">residual stream snapshots</text>
            <text x="58" y="78" class="small">横: 入力 token 数 / 各箱の幅: 埋込次元数 / 縦: layer</text>

            <g aria-label="input embeddings">
              <rect x="92" y="103" width="58" height="34" class="box soft-fill"></rect>
              <rect x="150" y="103" width="58" height="34" class="box soft-fill"></rect>
              <rect x="208" y="103" width="58" height="34" class="box soft-fill"></rect>
              <rect x="266" y="103" width="58" height="34" class="box soft-fill"></rect>
              <rect x="324" y="103" width="58" height="34" class="box soft-fill"></rect>
              <rect x="382" y="103" width="58" height="34" class="box soft-fill"></rect>
              <rect x="440" y="103" width="58" height="34" class="box soft-fill"></rect>
              <text x="58" y="126" text-anchor="start" class="caption">input</text>
              <text x="295" y="127" text-anchor="middle" class="small">token positions 1..入力 token 数</text>
            </g>

            <rect x="560" y="90" width="150" height="58" class="box blue-fill"></rect>
            <text x="635" y="113" text-anchor="middle" class="label">Layer 1</text>
            <text x="635" y="135" text-anchor="middle" class="small">Attention + MLP</text>
            <path d="M498 120 H556" class="arrow-line"></path>

            <g aria-label="layer 1 residual stream">
              <rect x="92" y="178" width="58" height="34" class="box"></rect>
              <rect x="150" y="178" width="58" height="34" class="box"></rect>
              <rect x="208" y="178" width="58" height="34" class="box"></rect>
              <rect x="266" y="178" width="58" height="34" class="box"></rect>
              <rect x="324" y="178" width="58" height="34" class="box"></rect>
              <rect x="382" y="178" width="58" height="34" class="box"></rect>
              <rect x="440" y="178" width="58" height="34" class="box"></rect>
              <text x="58" y="201" text-anchor="start" class="caption">after layer 1</text>
            </g>
            <path d="M635 148 C620 174 548 191 502 195" class="write-line"></path>

            <rect x="560" y="165" width="150" height="58" class="box blue-fill"></rect>
            <text x="635" y="188" text-anchor="middle" class="label">Layer 2</text>
            <text x="635" y="210" text-anchor="middle" class="small">読んで足す</text>
            <path d="M498 195 H556" class="arrow-line"></path>

            <g aria-label="layer 2 residual stream">
              <rect x="92" y="253" width="58" height="34" class="box"></rect>
              <rect x="150" y="253" width="58" height="34" class="box"></rect>
              <rect x="208" y="253" width="58" height="34" class="box"></rect>
              <rect x="266" y="253" width="58" height="34" class="box"></rect>
              <rect x="324" y="253" width="58" height="34" class="box"></rect>
              <rect x="382" y="253" width="58" height="34" class="box"></rect>
              <rect x="440" y="253" width="58" height="34" class="box warn-fill"></rect>
              <text x="58" y="276" text-anchor="start" class="caption">after layer 2</text>
            </g>
            <path d="M635 223 C620 249 548 266 502 270" class="write-line"></path>

            <text x="295" y="331" text-anchor="middle" class="small">...</text>

            <rect x="560" y="323" width="150" height="58" class="box blue-fill"></rect>
            <text x="635" y="346" text-anchor="middle" class="label">Layer n</text>
            <text x="635" y="368" text-anchor="middle" class="small">さらに更新</text>

            <g aria-label="layer n residual stream">
              <rect x="92" y="410" width="58" height="34" class="box"></rect>
              <rect x="150" y="410" width="58" height="34" class="box"></rect>
              <rect x="208" y="410" width="58" height="34" class="box"></rect>
              <rect x="266" y="410" width="58" height="34" class="box"></rect>
              <rect x="324" y="410" width="58" height="34" class="box"></rect>
              <rect x="382" y="410" width="58" height="34" class="box"></rect>
              <rect x="440" y="410" width="58" height="34" class="box warn-fill"></rect>
              <text x="58" y="433" text-anchor="start" class="caption">after layer n</text>
            </g>
            <path d="M635 381 C620 407 548 423 502 427" class="write-line"></path>

            <path d="M470 444 V482" class="arrow-line"></path>
            <rect x="390" y="486" width="160" height="34" class="box warn-fill"></rect>
            <text x="470" y="508" text-anchor="middle" class="small">final token vector</text>

            <rect x="750" y="414" width="150" height="58" class="box warn-fill"></rect>
            <text x="825" y="438" text-anchor="middle" class="label">unembedding</text>
            <text x="825" y="460" text-anchor="middle" class="small">次 token logits</text>
            <path d="M498 427 H746" class="arrow-line"></path>

            <path d="M510 112 V444" fill="none" stroke="#9fb1bd" stroke-width="1.4" stroke-dasharray="5 6"></path>
          </svg>
          <ul class="diagram-notes">
            <li><strong>読む</strong><br />Attention と MLP は、その時点の stream を入力として使う。</li>
            <li><strong>足す</strong><br />計算結果は上書きではなく、基本的に stream へ加算される。</li>
            <li><strong>形</strong><br />1 layer では <code>入力 token 数 x d_model</code>。全 layer を保存すると <code>layer 数 x 入力 token 数 x d_model</code>。</li>
          </ul>
        </div>
      </section>
```

```{=html}
<section class="screen">
        <p class="kicker">Transformer Refresher 2</p>
        <h2>attention head は「どこを見るか」と「何を書くか」を分けて考える</h2>
        <div class="diagram-block">
          <svg class="diagram-svg" viewBox="0 0 960 455" role="img" aria-labelledby="head-title head-desc">
            <title id="head-title">Attention head as information movement</title>
            <desc id="head-desc">
              A single attention head reads residual stream vectors at several token positions, computes an attention
              pattern using query-key scores, moves value information, and writes the result back to the destination
              token's residual stream.
            </desc>
            <text x="74" y="52" class="label">source positions</text>
            <rect x="48" y="78" width="140" height="58" class="box soft-fill"></rect>
            <text x="118" y="113" text-anchor="middle" class="small">The city</text>
            <rect x="48" y="150" width="140" height="58" class="box soft-fill"></rect>
            <text x="118" y="185" text-anchor="middle" class="small">Hangzhou</text>
            <rect x="48" y="222" width="140" height="58" class="box soft-fill"></rect>
            <text x="118" y="257" text-anchor="middle" class="small">China</text>

            <rect x="405" y="160" width="145" height="74" class="box warn-fill"></rect>
            <text x="477" y="190" text-anchor="middle" class="label">destination</text>
            <text x="477" y="214" text-anchor="middle" class="small">final token</text>

            <rect x="248" y="76" width="128" height="80" class="box blue-fill"></rect>
            <text x="312" y="107" text-anchor="middle" class="label">QK</text>
            <text x="312" y="132" text-anchor="middle" class="small">どこを見るか</text>
            <path d="M188 107 H244" class="arrow-line"></path>
            <path d="M405 180 C365 176 350 150 331 156" class="arrow-line"></path>
            <path d="M376 116 C478 112 561 119 651 133" class="arrow-line"></path>

            <rect x="248" y="252" width="128" height="80" class="box blue-fill"></rect>
            <text x="312" y="283" text-anchor="middle" class="label">OV</text>
            <text x="312" y="308" text-anchor="middle" class="small">何を書くか</text>
            <path d="M188 251 H244" class="arrow-line"></path>
            <path d="M376 292 C470 292 560 292 651 292" class="write-line"></path>

            <rect x="655" y="90" width="230" height="86" class="box"></rect>
            <text x="770" y="124" text-anchor="middle" class="label">attention pattern</text>
            <text x="770" y="149" text-anchor="middle" class="small">QK で得た参照重み</text>
            <path d="M770 176 V242" class="arrow-line"></path>

            <rect x="655" y="246" width="230" height="88" class="box"></rect>
            <text x="770" y="279" text-anchor="middle" class="label">head output</text>
            <text x="770" y="304" text-anchor="middle" class="small">重みづけた value の更新</text>
            <text x="770" y="326" text-anchor="middle" class="small">destination の stream へ加算</text>
            <path d="M655 286 C610 270 575 244 548 222" class="write-line"></path>

            <text x="48" y="390" class="caption">直感: head は、ある token 位置から別の token 位置へ、選んだ情報を運ぶ小さな読み書き部品。</text>
            <text x="48" y="417" class="caption">論文の head-level analysis は、この部品ごとに truth-sensitive な signal があるかを見る。</text>
          </svg>
          <ul class="diagram-notes">
            <li><strong>QK</strong><br />query と key の内積から attention pattern を作る部分。destination token が、どの source token をどれくらい参照するかを決める。</li>
            <li><strong>OV</strong><br />source token の情報を value として取り出し、output projection で書き込み用のベクトルに変換する部分。QK が作った重みと合わせて、何を residual stream に足すかを決める。</li>
            <li><strong>head 単位</strong><br />この論文の probe は QK/OV を個別に分解せず、attention head が最終的に書き込む head output 全体を見る。つまり「この head の更新に真偽情報が含まれるか」を調べる。</li>
          </ul>
        </div>
      </section>
```

```{=html}
<section class="screen">
        <p class="kicker">5.1 Accuracy</p>
        <h2>Accuracy は、内部ベクトルから真偽ラベルを読めるか</h2>
        <div class="diagram-block">
          <svg class="diagram-svg" viewBox="0 0 960 430" role="img" aria-labelledby="accuracy-title accuracy-desc">
            <title id="accuracy-title">Accuracy probing workflow</title>
            <desc id="accuracy-desc">
              Sentences are fed to the LLM without labels. Activations are collected from residual streams or attention
              heads. A supervised linear probe is trained afterwards using true and false labels.
            </desc>
            <rect x="42" y="78" width="220" height="92" class="box soft-fill"></rect>
            <text x="152" y="112" text-anchor="middle" class="label">入力は文だけ</text>
            <text x="152" y="139" text-anchor="middle" class="small">ラベルは入れない</text>
            <text x="152" y="164" text-anchor="middle" class="caption">"Hangzhou is in China."</text>

            <rect x="352" y="78" width="220" height="92" class="box blue-fill"></rect>
            <text x="462" y="112" text-anchor="middle" class="label">LLM forward pass</text>
            <text x="462" y="139" text-anchor="middle" class="small">各層の activation を保存</text>
            <text x="462" y="164" text-anchor="middle" class="caption">final token を probe</text>
            <path d="M262 124 H348" class="arrow-line"></path>

            <rect x="662" y="54" width="230" height="72" class="box"></rect>
            <text x="777" y="84" text-anchor="middle" class="label">residual vector</text>
            <text x="777" y="108" text-anchor="middle" class="small">層ごとの共有通路</text>
            <rect x="662" y="150" width="230" height="72" class="box"></rect>
            <text x="777" y="180" text-anchor="middle" class="label">head vector</text>
            <text x="777" y="204" text-anchor="middle" class="small">head ごとの局所出力</text>
            <path d="M572 116 C608 96 627 90 658 90" class="arrow-line"></path>
            <path d="M572 137 C609 159 627 185 658 186" class="arrow-line"></path>

            <rect x="198" y="276" width="260" height="88" class="box warn-fill"></rect>
            <text x="328" y="309" text-anchor="middle" class="label">教師ラベルは後で使う</text>
            <text x="328" y="335" text-anchor="middle" class="small">True / False dataset</text>
            <text x="328" y="358" text-anchor="middle" class="caption">activation と対応づける</text>

            <rect x="550" y="276" width="244" height="88" class="box soft-fill"></rect>
            <text x="672" y="309" text-anchor="middle" class="label">logistic regression</text>
            <text x="672" y="335" text-anchor="middle" class="small">ベクトル → True / False</text>
            <text x="672" y="358" text-anchor="middle" class="caption">分類精度が Accuracy</text>
            <path d="M458 320 H546" class="write-line"></path>
            <path d="M777 222 C780 260 750 277 731 276" class="arrow-line"></path>

            <text x="42" y="404" class="caption">要点: residual stream でも読める。一部 head output 全体には truth signal が局所的に現れる。</text>
          </svg>
          <ul class="diagram-notes">
            <li><strong>LLM 入力</strong><br />文だけ。True / False は prompt に入れない。</li>
            <li><strong>probe 学習</strong><br />取り出した activation に、外部の正解ラベルを対応づける。</li>
            <li><strong>意味</strong><br />内部表現に truth-sensitive な方向があるかの最低条件チェック。</li>
          </ul>
        </div>
      </section>
```

:::::: {.section .flow}
::: kicker
5.1 Accuracy / Dataset
:::

## 約1.3万文の True/False 文から activation を集める

Accuracy 実験では Samuel Marks and Max Tegmark (2024), *The Geometry of Truth* の True/False dataset を使う。文だけを LLM に入力し、final token 位置の residual stream / head output を取り出す。True/False ラベルは後から linear probe の教師ラベルとして使う。

::: compact-table
  domain          文数    例文                                                         label
  --------------- ------- ------------------------------------------------------------ -------
  Cities          1,496   The city of Hangzhou is in China.                            True
  Common Claims   4,450   Wild monkeys groom each other's hair as a social activity.   True
  Companies       1,200   Barclays has headquarters in Russia.                         False
  Larger          1,980   Fifty-six is larger than fifty-three.                        True
  Smaller         1,980   Sixty-five is smaller than eighty-seven.                     True
  Sp_En_Trans     354     The Spanish word 'madre' means 'mother'.                     True
  Counterfact     2,000   Klemens von Metternich's profession is an actor.             False
:::

::: note
合計は約13,460文。Accuracy では半分を Use 実験用に予約し、残り半分で probe を訓練・評価する。 1文につき、各 layer の final-token residual vector と、各 layer・各 head の final-token head output を読む。
:::
::::::

::::::: {.section .flow}
::: kicker
5.1 Accuracy / Results
:::

## Llama / Gemma 系では真偽を高精度に読める

層や head の強さは、probe の重みの大きさではなく、その layer / head の activation だけで True/False を分類した test accuracy で見る。本文では residual stream の Top-3 probe accuracy と、 head-level の傾向が報告されている。

下の `Heads` は multi-head 全体を結合した分類器ではない。各 layer/head を個別に probe し、成績の高い上位5個を平均した探索的な集約である。head 位置を別データで事前固定してから評価したスコアではないので、モデル全体の汎化性能としては強めに出る。

::: compact-table
  モデル        本文での residual probe accuracy   読み方
  ------------- ---------------------------------- -------------------------------------------------------
  GPT-2 Large   0.567                              ほぼ chance に近く、truth-sensitive encoding は弱い。
  Yi            0.630                              読めるが弱い。
  Pythia        0.721                              中程度に読める。
  Llama         0.889                              高精度に読める。
  Gemma         0.920                              非常に高精度に読める。
:::

::: compact-table
  モデル           Residual   Heads   補足
  ---------------- ---------- ------- ---------------------------------------------------------------
  GPT-J            0.799      0.718   上位5 activation 平均。以後の実験では baseline 的に扱われる。
  Llama            0.895      0.857   residual stream からも強く読める。
  Llama Instruct   0.882      0.899   instruction tuning 後も head-level signal が強い。
  Gemma            0.916      0.911   residual / heads がほぼ同程度。
  Gemma Instruct   0.923      0.925   head-level でも非常に高い。
:::

::: note
residual stream 全体からも True/False は読める。ただし全 head が同じではない。 一部の layer・head output に truth signal が局所的に現れるため、5.2 Use ではそこを steering 対象にする。
:::
:::::::

::::::::: {.section .flow}
::: kicker
5.2 Use
:::

## 読める truth direction は、出力も動かせるのか

Accuracy は「内部から真偽を読めるか」だった。Use は一歩進んで、Accuracy で見つけた truth-sensitive direction に沿って activation を steering し、モデルの True/False 出力が 実際に変わるかを見る。

:::::: axis
::: panel
**1. direction を作る**

True 文の activation 平均と False 文の activation 平均の差を取る。

    truth direction
    = mean(True activations)
    - mean(False activations)
:::

::: arrow
→
:::

::: panel
**2. activation を動かす**

上位 K 個の truth-sensitive layer / head output に方向ベクトルを足す。

    activation'
    = activation
    + alpha * direction
:::
::::::

::: note
目的は「わざと間違った truth-value answer を引き出せるか」。False → True と True → False の両方向で、正解 token と不正解 token の確率が介入前後でどう動くかを見る。
:::
:::::::::

:::::: {.section .flow}
::: kicker
5.2 Use / Results
:::

## head steering は小さい介入で効きやすい

Llama / Gemma 系では steering が概ね成功し、GPT-J は反応が弱い。instruction-tuned models は base models より steering sensitivity が大きい。attention head への介入は、残差ストリームへの介入より小さい正規化強度で効果を出しやすい、というのがこのスライドの読みどころである。

::: note
`K` と `α` は固定値ではなく、モデル・介入対象・方向ごとに grid search で選ばれている。論文では `E/S` が大きくなる設定を選び、Table 2 に `|α|` と `K` を報告している。
:::

:::::: axis
::: panel
**Residual stream への介入**

layer ごとの残差ストリームに、真偽方向を足す。

    r(l)' = r(l) + alpha * theta_l

実際には全 layer ではなく、truth-sensitive な上位 `K` layer だけに足す。
:::

::: arrow
→
:::

::: panel
**Head output への介入**

layer/head ごとの head output に、真偽方向を足す。

    h(l,i)' = h(l,i) + alpha * theta_(l,i)

こちらも全 head ではなく、truth-sensitive な上位 `K` head だけに足す。
:::
::::::

::: {.compact-table .data-table}
| model | False→True Residual | False→True Heads | True→False Residual | True→False Heads |
|---|---:|---:|---:|---:|
| Llama | `α=9, K=1` | `α=3, K=40` | `α=6, K=1` | `α=9, K=1` |
| Llama Instruct | `α=3, K=7` | `α=2, K=20` | `α=5, K=2` | `α=3, K=10` |
| Gemma | `α=31, K=7` | `α=12, K=15` | `α=33, K=22` | `α=10, K=60` |
| Gemma Instruct | `α=30, K=16` | `α=10, K=65` | `α=30, K=26` | `α=14, K=25` |
| GPT-J | `α=15, K=4` | `α=2, K=5` | `α=30, K=15` | `α=10, K=50` |
:::

::: compact-table
  model            direction      Residual effect   Head effect   読み方
  ---------------- -------------- ----------------- ------------- --------------------------------
  Llama Instruct   False → True   1.23              1.23          どちらも強く出力を動かす。
  Llama Instruct   True → False   0.90              1.23          head 側も強い。
  Gemma Instruct   False → True   0.54              0.87          head steering の効果が大きい。
  Gemma Instruct   True → False   1.07              1.48          head steering が最も強い。
  GPT-J            False → True   0.05              0.05          ほぼ動かない。
  GPT-J            True → False   0.20              0.09          弱い baseline 的な挙動。
:::

::: note
解釈: truth-sensitive direction は単に probe で読めるだけではなく、少なくともこの True/False 出力設定では出力計算に機能的に関与している可能性がある。ただし `K/α` は探索で選ばれているため、「自然にこの個数だけ介入すればよい」という結果ではなく、truth-sensitive な場所を動かすとどれくらい効率よく出力が変わるかを見る実験として読む。
:::
::::::

:::::::: {.section .flow}
::: kicker
5.3 Coherence
:::

## 真偽を読めても、論理的に一貫するとは限らない

Coherence は、truth-sensitive representation が否定・連言・選言に対してどれくらい整合的かを見る。 belief-like と言うなら、少なくとも p と not-p を同時に強く true っぽく表現していては困る。

::::: two-col
::: panel
**logical coherence**

元の True/False 文から negation, conjunction, disjunction を作り、probe が分類できるかを見る。

    p: Hangzhou is in China.
    not p: Hangzhou is not in China.
    p and q
    p or q
:::

::: panel
**probabilistic coherence**

probe の連続出力を疑似確率として読み、確率的な制約を満たすかを見る。

    P(p) + P(not p) ≈ 1
    P(p and q) <= P(p)
    P(p) <= P(p or q)
:::
:::::

::: {.note .warn}
ここは本論文の慎重に読むべき部分。Accuracy と Use は強いが、Coherence は中程度で、特に negation が弱い。
:::
::::::::

:::::: {.section .flow}
::: kicker
5.3 Coherence / Results
:::

## Coherence は中程度、negation が弱い

logical task では全体として中程度の coherence が見られる。ただし Common Claims の negated statements で linear probes の accuracy が落ちる。probabilistic experiment では、calibrated logistic regression probes が self-report や logits より coherent な probability を出す場合がある。

::: compact-table
  model            negated common claims accuracy   読み方
  ---------------- -------------------------------- ----------------------------------
  Llama            0.51                             ほぼ chance。
  Llama Instruct   0.59                             少し改善するが弱い。
  Gemma            0.56                             弱い。
  Gemma Instruct   0.67                             相対的には良いが十分強くはない。
  GPT-J            0.44                             chance 未満。
:::

::: {.note .warn}
truth direction はあるが、線形 probe だけでは generalized negation を安定して扱えない。 情報抽出では negation、条件、absent/null、unsupported inference に注意が必要になる。
:::
::::::

:::::: {.section .flow}
::: kicker
5.4 Uniformity / Results
:::

## 多様な domain で訓練すると、truth direction は一般化する

結果は residual level と head level の両方で強い。特に複数 domain を含む大きな訓練セットでは、 各 test domain への平均 accuracy が高く、worst domain でも chance を上回る。 instruction-tuned models は base models より cross-domain consistency が高い傾向がある。

::: compact-table
  train set            model                    average / worst test acc.   読み方
  -------------------- ------------------------ --------------------------- ------------------------------------------------------
  large multi-domain   Llama                    0.87 / 0.74                 平均も worst も高く、domain 専用方向ではなさそう。
  large multi-domain   Llama Instruct           0.87 / 0.72                 base と同程度に強い。
  large multi-domain   Gemma                    0.88 / 0.68                 平均は高いが、弱い domain は残る。
  large multi-domain   Gemma Instruct           0.90 / 0.74                 この設定では最も安定。
  Common Claims only   Llama / Llama Instruct   0.64 / 0.57, 0.75 / 0.58    汎用文だけでも一部 generalize するが、worst は弱い。
  Common Claims only   Gemma / Gemma Instruct   0.75 / 0.66, 0.77 / 0.50    平均は良いが、domain によって崩れる。
:::

::: {.note .warn}
literal / factual な True/False 文に限れば、truth signal は domain-robust。 ただし皮肉・比喩・語用論的転用のように、文脈で命題内容が変わるケースまでは検査していない。
:::
::::::

::::::::: {.section .screen}
::: kicker
Paper 2
:::

## Thinking Out Loud

::: lead
reasoning model は高性能になっただけでなく、自分の正誤もよりよく分かるのか。 verbalized confidence と \`I don\'t know\` の挙動から評価する。
:::

:::::: three-col
::: panel
**reasoning-heavy tasks** reasoning SFT と reasoning RL は accuracy と calibration を改善する。
:::

::: panel
**factuality** 小規模 reasoning model は \`I don\'t know\` が減り、知識境界の認識が弱まる可能性がある。
:::

::: panel
**注意点** 推論能力の向上は、自己認識や abstention 能力の向上と同じではない。
:::
::::::
:::::::::

:::::::::: {.section .flow}
::: kicker
Paper 2 / Post-training
:::

## 比較軸は post-training

この論文のモデル選定は、モデルを広く並べるというより、pretraining 後にどんな訓練を足したかを見る設計である。 同じくらいのサイズや近い系列で、Instruct、SFT reasoning、RL reasoning を比べる。

:::::: axis
::: panel
**pretrained base**

大量テキストで next-token prediction を学習した土台。ここだけでは、指示追従や confidence 表明は安定しにくい。
:::

::: arrow
→
:::

::: panel
**post-training**

SFT や RL で、指示追従、長い reasoning chain、自己反省的な振る舞い、alignment を後から強める。
:::
::::::

::: compact-table
  post-training の種類              訓練のイメージ                                                    代表モデル                                    この論文での関心
  --------------------------------- ----------------------------------------------------------------- --------------------------------------------- ------------------------------------------------------------------
  general instruction / alignment   ユーザー指示に従う、答えの形式を守る、安全性や有用性を高める。    Qwen2.5-14B/32B-Instruct, DeepSeek-V3         通常の instruct model は confidence calibration の基準線になる。
  reasoning SFT                     長い chain-of-thought や reasoning trace を真似る。               DeepSeek-R1-Distill-Qwen-14B/32B              推論能力だけでなく、verbalized confidence もよくなるか。
  reasoning RL                      結果の良さを報酬にして、探索・検算・反省的 reasoning を強める。   DeepCoder-14B, Skywork-OR1-32B, DeepSeek-R1   SFT よりさらに confidence と correctness の対応が改善するか。
:::

::: note
ここでの関心は「どの事前学習モデルが confidence 表明を得意とするか」ではない。 post-training が confidence 表明にどう効くかを見る。
:::
::::::::::

:::::: {.section .flow}
::: kicker
Paper 2 / Prompting 1
:::

## confidence は、出力として言わせて測る

この論文は内部 activation を読まず、モデルに回答と confidence を XML 形式で出させる。 その confidence と実際の正誤がどれくらい合うかを ECE / ACE / AUROC / AUPRC で測る。

::: compact-table
  prompting strategy    confidence の出させ方                                                                         例                                                             狙い
  --------------------- --------------------------------------------------------------------------------------------- -------------------------------------------------------------- ---------------------------------------------------------------------
  Vanilla CoT           step-by-step で解かせ、最後に 0%\--100% の confidence score を出させる。                      \`\<confidence\>80%\</confidence\>\`                           通常の verbalized confidence の基準線。
  Vanilla CoT w. Prob   同じく解かせるが、confidence を 0.0\--1.0 の probability score として出させる。               \`\<confidence\>0.8\</confidence\>\`                           確率値として聞くと calibration が改善するという先行研究を確認する。
  Self-reflection       1回目で回答を出させ、2回目でその problem と solution を見せて confidence だけを評価させる。   \`solution\` を再読して \`\<confidence\>80%\</confidence\>\`   一度答えたあとに自己評価させると、正誤認識が改善するかを見る。
:::

::: note
ここで測っているのは「内部に truth signal があるか」ではない。モデルが外に出した confidence が empirical accuracy と合うかである。
:::
::::::

:::::: {.section .flow}
::: kicker
Paper 2 / Results 1
:::

## reasoning-heavy tasks では、推論訓練で accuracy も calibration も改善

AIME や LiveBench-Reasoning では、Instruct から SFT reasoning へ進むと accuracy が大きく上がり、 ECE も下がる。さらに RL reasoning は、SFT 後に calibration / failure prediction を追加で改善する傾向がある。

::: compact-table
  比較                   task        Acc ↑           ECE ↓           AUROC ↑         読み方
  ---------------------- ----------- --------------- --------------- --------------- --------------------------------------------
  Qwen2.5-14B Instruct   AIME        11.3%           0.760           0.670           低精度かつ過信寄り。
  R1-Distill-Qwen-14B    AIME        46.7%           0.342           0.847           SFT reasoning で大きく改善。
  DeepCoder-14B          AIME        57.7%           0.222           0.873           RL reasoning でさらに calibration が良い。
  Qwen2.5-32B Instruct   LiveBench   42.7%           0.472           0.556           難しい reasoning では confidence が弱い。
  R1-Distill-Qwen-32B    LiveBench   73.3%           0.152           0.777           SFT reasoning で精度・較正とも改善。
  Skywork-32B            LiveBench   84.7%           0.074           0.876           RL reasoning が最も良い。
  DeepSeek-V3 → R1       LiveBench   50.0% → 89.3%   0.389 → 0.081   0.696 → 0.908   大規模 RL reasoning で強い改善。
:::

::: note
reasoning-heavy な問題では、長く考えられるようにする訓練は性能だけでなく verbalized confidence の信頼性も改善しやすい。
:::
::::::

::::::: {.section .flow}
::: kicker
Paper 2 / Results 2
:::

## factuality では、reasoning model が「分からない」と言いにくくなる

SimpleQA / FreshQA では、reasoning models は \`I don\'t know\` に相当する not attempted response を大きく減らす。 しかし、小規模モデルでは accuracy が十分に上がらず、むしろ calibration が悪化する場合がある。

::: compact-table
  比較枠            not attempted: Instruct   SFT reasoning   RL reasoning   読み方
  ----------------- ------------------------- --------------- -------------- ----------------------------------------------------------
  14B family        1136                      102             103            reasoning 化で abstention が激減。
  32B family        2492                      76              63             より大きいモデルでも同じ傾向。
  DeepSeek family   480                       \-              81             14B/32B とサイズを揃えた比較ではなく、V3/R1 の別枠比較。
:::

::: compact-table
  ----------------------------------------------------------------------------------------------------
  比較枠                  Shared attempted\                     Only LRMs attempted\
                          Instruct も LRM も答えた問題          Instruct は避け、LRM だけ答えた問題
  ----------------------- ------------------------------------- --------------------------------------
  14B family              × Acc は下がり、ECE は悪化\           × 追加で答えてもほぼ当たらない\
                          Instruct 12.5% / 0.598\               SFT 2.37% / 0.718, RL 2.75% / 0.690
                          SFT 10.5% / 0.692, RL 9.98% / 0.684   

  32B family              △ Acc は横ばい、ECE は悪化\           × 追加で答えてもほぼ当たらない\
                          Instruct 17.4% / 0.591\               SFT 3.7% / 0.717, RL 3.23% / 0.653
                          SFT 17.5% / 0.640, RL 17.1% / 0.600   

  DeepSeek family         ○ R1 は V3 より Acc / ECE とも改善\   △ R1 は追加問題も多少当てるが難しい\
                          V3 27.5% / 0.496\                     R1 11.4% / 0.371
                          R1 34.6% / 0.317                      
  ----------------------------------------------------------------------------------------------------
:::

::: {.note .warn}
reasoning は「考えて答える」力を上げるが、「知らないときに止まる」力を自動的に上げるわけではない。
:::
:::::::

::::::::: {.section .screen}
::: kicker
Readout Problem
:::

## 内部状態と出力の対応は、訓練と聞き方で変わる

:::::: axis
::: panel
**内部状態** LLM は truth-sensitive な表現を持ちうる。 ただしそれは局所的で、論理的に完全に coherent とは限らない。
:::

::: arrow
→ 
:::

::: panel
**出力 channel** answer、verbalized confidence、abstention はタスク・訓練・prompt に依存する。 factuality では過信や非 abstention が問題になる。
:::
::::::

::: {.note .warn}
truth-sensitive な内部表象、belief-like representation、confidence の自己申告、abstention は別物である。問題は、それぞれの間の readout がどこで faithful になり、どこで崩れるかである。
:::
:::::::::

:::: {.section .screen}
::: kicker
Expected Takeaway
:::

## 今日のまとめ

::: lead
今日の結論は、LLMが「知っているか」を一語で判定しないこと。内部に読める真偽情報があること、真として使われること、確信や abstention として外に出ることは、それぞれ別に確かめる必要がある。
:::

:::::: three-col
::: panel
**地図を固定する**

Truth / Representation / Belief-like state / Confidence / Output を分ける。論文間の違いも、評価指標の違いも、まずこの地図に置くと読みやすい。
:::

::: panel
**内部について**

Paper 1 では truth-sensitive な方向はかなり読めるし、出力も動かせる。ただし negation や coherence で弱さが残るので、「信念」と呼ぶには条件つきで読む。
:::

::: panel
**外への出方について**

Paper 2 では reasoning 訓練で confidence の較正がよくなる場面がある一方、factuality では `I don't know` が出にくくなる。出力 channel は訓練と聞き方で変わる。
:::
::::::

::: quote
持ち帰る問い: それは内部にある話か、外に出た振る舞いの話か。その対応は faithful か。
:::
::::
