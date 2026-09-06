<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="tei">

  <xsl:output method="html" html-version="5" encoding="UTF-8" indent="yes"/>
  <xsl:mode on-no-match="shallow-skip"/>

  <xsl:template match="/tei:TEI">
    <html lang="it">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title><xsl:value-of select="tei:teiHeader//tei:title[@type='main'][1]"/></title>
        <link rel="stylesheet" href="edition.css"/>
        <script src="edition.js" defer="defer"/>
      </head>
      <body>
        <header class="masthead">
          <p class="eyebrow">Edizione digitale critica</p>
          <h1><xsl:value-of select="tei:teiHeader//tei:title[@type='main'][1]"/></h1>
          <div class="tools">
            <button type="button" data-action="translation" aria-pressed="false">Traduzione</button>
            <button type="button" data-action="lemmas" aria-pressed="false">Lemmi</button>
          </div>
        </header>

        <main>
          <div class="reading-desk">
            <article class="parchment latin">
              <xsl:apply-templates select=".//tei:div[not(@type='translation')]/tei:head[1]"/>
              <div class="verse-block">
                <xsl:apply-templates
                  select=".//tei:lg[@type='poem'][not(ancestor::tei:div[@type='translation'])]/tei:l"/>
              </div>
            </article>

            <aside class="parchment translation" hidden="hidden">
              <h2>Traduzione</h2>
              <div class="verse-block">
                <xsl:apply-templates select=".//tei:div[@type='translation']//tei:l"
                                     mode="translation"/>
              </div>
            </aside>
          </div>
        </main>

        <aside id="apparatus" class="apparatus">
          <div class="apparatus-bar">
            <div role="tablist">
              <button role="tab" data-tab="critical" aria-selected="true">Critico</button>
              <button role="tab" data-tab="fontium" aria-selected="false">Fontium</button>
              <button role="tab" data-tab="iterati" aria-selected="false">Versus iterati</button>
            </div>
            <button type="button" data-action="expand-apparatus"
                    aria-expanded="false">Espandi</button>
          </div>

          <section id="critical" role="tabpanel" class="app-panel">
            <xsl:apply-templates select=".//tei:app[@type='critical']" mode="apparatus"/>
          </section>

          <section id="fontium" role="tabpanel" class="app-panel" hidden="hidden">
            <xsl:apply-templates select=".//tei:note[@type='fontium']" mode="linked-note"/>
          </section>

          <section id="iterati" role="tabpanel" class="app-panel" hidden="hidden">
            <xsl:apply-templates select=".//tei:note[@type='iterati']" mode="linked-note"/>
          </section>
        </aside>

        <div id="lemma-popover" role="status" hidden="hidden"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="tei:head">
    <h2><xsl:apply-templates/></h2>
  </xsl:template>

  <xsl:template match="tei:l">
    <p class="verse" id="{@xml:id}">
      <span class="line-number"><xsl:value-of select="@n"/></span>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="tei:l" mode="translation">
    <p class="verse" data-corresp="{replace(@corresp, '#', '')}">
      <span class="line-number"><xsl:value-of select="@n"/></span>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="tei:w">
    <span class="word" data-lemma="{@lemma}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:app">
    <xsl:variable name="n" select="count(preceding::tei:app) + 1"/>
    <span class="app-reading" id="reading-{$n}" data-app="app-{$n}">
      <xsl:apply-templates select="tei:lem/node()"/>
      <button class="app-marker" type="button" data-app="app-{$n}"
              aria-label="Apri apparato {$n}">
        <xsl:value-of select="$n"/>
      </button>
    </span>
  </xsl:template>

  <xsl:template match="tei:anchor">
    <span id="{@xml:id}" class="anchor"/>
  </xsl:template>

  <xsl:template match="tei:app" mode="apparatus">
    <xsl:variable name="n" select="count(preceding::tei:app) + 1"/>
    <article class="app-entry" id="app-{$n}" data-reading="reading-{$n}">
      <button class="app-backlink" type="button" data-reading="reading-{$n}">
        <xsl:value-of select="$n"/>
      </button>
      <p>
        <strong>v. <xsl:value-of select="ancestor::tei:l/@n"/> — </strong>
        <span class="lemma"><xsl:apply-templates select="tei:lem/node()"/></span>
        <xsl:for-each select="tei:rdg">
          <span class="reading">
            <xsl:text> : </xsl:text>
            <xsl:apply-templates/>
            <xsl:text> </xsl:text>
            <em><xsl:value-of select="replace(normalize-space(concat(@wit,' ',@source,' ',@resp)), '#', '')"/></em>
          </span>
        </xsl:for-each>
      </p>
      <xsl:if test="tei:note">
        <p class="editorial-note"><xsl:apply-templates select="tei:note/node()"/></p>
      </xsl:if>
    </article>
  </xsl:template>

  <xsl:template match="tei:note" mode="linked-note">
    <article class="linked-entry">
      <xsl:for-each select="tokenize(normalize-space(@target), '\s+')">
        <a href="{.}" data-target="{substring-after(., '#')}">
          <xsl:value-of select="substring-after(., '#')"/>
        </a>
        <xsl:text> </xsl:text>
      </xsl:for-each>
      <p><xsl:apply-templates/></p>
    </article>
  </xsl:template>
</xsl:stylesheet>