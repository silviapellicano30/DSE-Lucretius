<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="tei">
  <xsl:output method="html" html-version="5" encoding="UTF-8" indent="yes"/>
  <xsl:mode on-no-match="shallow-skip"/>
  <xsl:template match="text()"><xsl:value-of select="."/></xsl:template>

  <xsl:template match="/tei:TEI">
    <html lang="en"><head>
      <meta charset="UTF-8"/>
      <meta name="viewport" content="width=device-width, initial-scale=1"/>
      <title><xsl:value-of select="tei:teiHeader//tei:title[@type='main'][1]"/></title>
      
      <!-- Import dei caratteri Cinzel ed EB Garamond -->
      <link rel="preconnect" href="https://fonts.googleapis.com"/>
      <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="crossorigin"/>
      <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@500;700&amp;family=EB+Garamond:ital,wght@0,400;0,600;1,400&amp;display=swap" rel="stylesheet"/>
      
      <link rel="stylesheet" href="edition-v3.css"/>
      <script src="edition-v3.js" defer="defer"/>
    </head><body>
      <header class="masthead">
        <p class="eyebrow">Digital critical edition</p>
        <h1>De rerum natura</h1>
        <p class="subtitle">Titus Lucretius Carus</p>
        
        <div class="tools-container">
          <!-- Fila 1: Azioni sul testo dell'edizione -->
          <div class="tools-row-edition">
            <button type="button" data-action="translation" aria-pressed="false">Translation</button>
            <button type="button" data-action="lemmas" aria-pressed="false">Lemmatization</button>
            <button type="button" data-action="keywords" aria-pressed="false">Keywords</button>
          </div>
          
          <!-- Fila 2: Navigazione verso pagine esterne (stile rosso squadrato) -->
          <div class="tools-row-navigation">
            <a href="keywords.html" class="nav-link-btn">Explore the Keywords</a>
            <a href="scholars.html" class="nav-link-btn">Meet the Scholars</a>
          </div>
        </div>
      </header>
      <main><div class="reading-desk">
        <article class="parchment latin">
          <h2>Book III: Proem</h2>
          <p class="section-label">Lines 1–22</p>
          <div class="verse-block">
            <xsl:apply-templates select="tei:text/tei:body/tei:div[@type='prooemium']/tei:lg[@type='poem']/tei:l"/>
          </div>
        </article>
        <aside class="parchment translation" hidden="hidden">
          <h2>Translation</h2><p class="section-label">Lines 1–22</p>
          <div class="verse-block">
            <xsl:apply-templates select="tei:text/tei:body/tei:div[@type='prooemium']/tei:div[@type='translation']//tei:l" mode="translation"/>
          </div>
        </aside>
      </div></main>
      <aside id="apparatus" class="apparatus">
        <div class="apparatus-bar"><div role="tablist">
          <button role="tab" data-tab="critical" aria-selected="true">Critical apparatus</button>
          <button role="tab" data-tab="fontium" aria-selected="false">Sources</button>
          <button role="tab" data-tab="iterati" aria-selected="false">Parallel passages</button>
        </div><button type="button" data-action="expand-apparatus" aria-expanded="false">Expand</button></div>
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
    </body></html>
  </xsl:template>

  <xsl:template match="tei:head"><h2><xsl:apply-templates/></h2></xsl:template>
  <xsl:template match="tei:l"><p class="verse" id="{@xml:id}"><span class="line-number"><xsl:value-of select="@n"/></span><span class="verse-text"><xsl:apply-templates/></span></p></xsl:template>
  <xsl:template match="tei:l" mode="translation"><p class="verse" data-corresp="{substring-after(@corresp,'#')}"><span class="line-number"><xsl:value-of select="@n"/></span><span class="verse-text"><xsl:apply-templates/></span></p></xsl:template>
  <xsl:template match="tei:w"><span class="word" data-lemma="{@lemma}"><xsl:if test="@join"><xsl:attribute name="data-join" select="@join"/></xsl:if><xsl:apply-templates/></span></xsl:template>
  <xsl:template match="tei:seg[@type='parallel']"><span class="parallel-locus" data-note="{substring-after(@corresp,'#')}"><xsl:apply-templates/></span></xsl:template>
  <xsl:template match="tei:seg[@type='parallel-phrase']"><em class="parallel-phrase"><xsl:apply-templates/></em></xsl:template>
  <xsl:template match="tei:seg[@type='short-reference']"><small class="short-reference"><xsl:apply-templates/></small></xsl:template>
  <xsl:template match="tei:app">
    <xsl:variable name="n" select="count(preceding::tei:app[@type='critical']) + 1"/>
    <span class="app-reading" id="reading-{$n}" data-app="app-{$n}"><xsl:apply-templates select="tei:lem/node()"/><button type="button" class="app-marker" data-app="app-{$n}" aria-label="Apri variante {$n}"><xsl:value-of select="$n"/></button></span>
  </xsl:template>
  <xsl:template match="tei:anchor"><span id="{@xml:id}" class="anchor"/></xsl:template>
  <xsl:template match="tei:app" mode="apparatus">
    <xsl:variable name="n" select="count(preceding::tei:app[@type='critical']) + 1"/>
    <article class="app-entry" id="app-{$n}" data-reading="reading-{$n}">
      <button type="button" class="app-id" data-reading="reading-{$n}" aria-label="Torna al testo"><xsl:value-of select="$n"/></button>
      <span class="app-locus">v. <xsl:value-of select="ancestor::tei:l/@n"/></span>
      <div class="app-content"><span class="variant"><xsl:call-template name="render-evidence"><xsl:with-param name="tokens" select="tei:lem/@wit"/><xsl:with-param name="kind" select="'witness'"/></xsl:call-template><xsl:call-template name="render-evidence"><xsl:with-param name="tokens" select="tei:lem/@source"/><xsl:with-param name="kind" select="'source'"/></xsl:call-template><xsl:call-template name="render-evidence"><xsl:with-param name="tokens" select="tei:lem/@resp"/><xsl:with-param name="kind" select="'scholar'"/></xsl:call-template><em class="reading-form"><xsl:apply-templates select="tei:lem/node()"/></em></span>
        <xsl:for-each select="tei:rdg"><span class="variant"><xsl:text>   </xsl:text><xsl:call-template name="render-evidence"><xsl:with-param name="tokens" select="@wit"/><xsl:with-param name="kind" select="'witness'"/></xsl:call-template><xsl:call-template name="render-evidence"><xsl:with-param name="tokens" select="@source"/><xsl:with-param name="kind" select="'source'"/></xsl:call-template><xsl:call-template name="render-evidence"><xsl:with-param name="tokens" select="@resp"/><xsl:with-param name="kind" select="'scholar'"/></xsl:call-template><em class="reading-form"><xsl:apply-templates/></em></span></xsl:for-each>
        <xsl:if test="tei:note"><p class="editorial-note"><xsl:apply-templates select="tei:note/node()"/></p></xsl:if>
      </div>
    </article>
  </xsl:template>
  <xsl:template name="render-evidence">
    <xsl:param name="tokens"/>
    <xsl:param name="kind"/>
    <xsl:variable name="root" select="root(.)"/>
    <xsl:if test="normalize-space($tokens)">
    <xsl:choose>
    <xsl:when test="$kind='scholar'">
    <span class="evidence-group">
    <xsl:for-each select="tokenize(normalize-space(replace($tokens,'#','')),'\s+')">
      <xsl:variable name="id" select="."/>
      <span class="{if ($id='Omega') then 'stem archetype' else if ($id=('O','Gamma')) then 'stem primary' else if ($id=('Lact','Non')) then 'stem ancient' else if ($kind='scholar') then 'stem scholar' else 'stem secondary'}">
        <xsl:choose>
          <xsl:when test="$kind='witness'"><xsl:value-of select="$root//tei:witness[@xml:id=$id]/tei:abbr"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="$root//tei:person[@xml:id=$id]/tei:persName"/></xsl:otherwise>
        </xsl:choose>
      </span>
      <xsl:if test="position() ne last()"><xsl:text>, </xsl:text></xsl:if>
      <xsl:text> </xsl:text>
    </xsl:for-each>
    </span>
    </xsl:when>
    <xsl:otherwise>
    <xsl:for-each select="tokenize(normalize-space(replace($tokens,'#','')),'\s+')">
      <xsl:variable name="id" select="."/>
      <span class="evidence-group">
        <span class="{if ($id='Omega') then 'stem archetype' else if ($id=('O','Gamma')) then 'stem primary' else if ($id=('Lact','Non')) then 'stem ancient' else 'stem secondary'}">
          <xsl:choose>
            <xsl:when test="$kind='witness'"><xsl:value-of select="$root//tei:witness[@xml:id=$id]/tei:abbr"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="$root//tei:person[@xml:id=$id]/tei:persName"/></xsl:otherwise>
          </xsl:choose>
        </span>
      </span>
      <xsl:text> </xsl:text>
    </xsl:for-each>
    </xsl:otherwise>
    </xsl:choose>
    <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>
  <xsl:template match="tei:note[@type='iterati']" mode="linked-note">
    <article class="linked-entry parallel-entry" data-parallel-target="{@xml:id}">
      <span>
        <xsl:apply-templates select="tei:seg[@type='parallel-phrase']"/>
        <xsl:text> (III.7) echoes a similar internal parallel at II.367 (</xsl:text>
        <xsl:apply-templates select="tei:quote/node()"/>
        <xsl:text>), where the image of newborn goats is likewise characterized by trembling.</xsl:text>
        <xsl:apply-templates select="tei:seg[@type='short-reference']"/>
      </span>
    </article>
  </xsl:template>
  <xsl:template match="tei:note" mode="linked-note"><article class="linked-entry" id="{@xml:id}"><xsl:for-each select="tokenize(normalize-space(@target),'\s+')"><a href="{.}" data-target="{substring-after(.,'#')}"><xsl:value-of select="substring-after(.,'#')"/></a><xsl:text> </xsl:text></xsl:for-each><span><xsl:apply-templates/></span></article></xsl:template>
  <xsl:template match="tei:term">
    <a href="keywords.html#{substring-after(@ref, '#')}" class="keyword-term" data-term="{substring-after(@ref, '#')}">
      <xsl:apply-templates/>
    </a>
  </xsl:template>
</xsl:stylesheet>


