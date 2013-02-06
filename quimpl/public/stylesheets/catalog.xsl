<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>
    <!-- TODO customize transformation rules 
         syntax recommendation http://www.w3.org/TR/xslt 
    -->
    <xsl:template match="/">
        <html>
            <head>
                <title>Quiz Catalog</title>
            </head>
            <body>
                Select your quiz

                <xsl:for-each select="//quiz_detail">
                    <div>
                        <h2><xsl:value-of select="quiz_metadata/title" /></h2>

                        <form method="POST" action="/quizzes">
                            
                            <input type="hidden" name="submit_to">
                            <xsl:attribute name="value">
                                <xsl:value-of select="quiz_metadata/start_quiz_uri" />
                            </xsl:attribute>
                            </input>
                            <input type="hidden" name="user_id" value="1234" />
                            <xsl:apply-templates select="quiz_metadata/post_parameter" />

                            <xsl:apply-templates select="lead_question/quiz_question" />
                            <input type="submit" value="Continue &gt;" />
                        </form>

                    </div>
                    <br/>
                </xsl:for-each>

            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="answer_option">
        <div>
            <label>
                <xsl:attribute name="for">
                    <xsl:value-of select="post_parameter/value" />
                </xsl:attribute>
                <xsl:value-of select="answer_option_text" />
                
            </label>
            <xsl:apply-templates select="post_parameter" />
        </div>
    </xsl:template>
    
    
    <xsl:template match="quiz_question">
        <h3>
            <xsl:value-of select="question_text" />
        </h3>
        <xsl:apply-templates select="answer_option" />
    </xsl:template>
    
    
    <xsl:template match="post_parameter">
        <input>
            <xsl:attribute name="id">
                <xsl:value-of select="value" />
            </xsl:attribute>

            <xsl:attribute name="name">
                <xsl:value-of select="name" />
            </xsl:attribute>

            <xsl:attribute name="type">
                <xsl:value-of select="type" />
            </xsl:attribute>

            <xsl:attribute name="value">
                <xsl:value-of select="value" />
            </xsl:attribute>
            
        </input>
    </xsl:template>

</xsl:stylesheet>