<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>

    <!-- TODO customize transformation rules 
         syntax recommendation http://www.w3.org/TR/xslt 
    -->
    <xsl:template match="/">

        <html>
            <head>
                <title>Quiz Result</title>
            </head>
            <body>
                <xsl:apply-templates select="/quiz_request/completed_quiz_result" />
            </body>
        </html>

    </xsl:template>

    <xsl:template match="completed_quiz_result">

        <h1>You've completed your quiz!</h1>

        <div>
            <xsl:value-of select="overall_recommendation_text">
        </div>

        <div>
            <h2>Here is a closer look at the answers you selected.</h2>

            <xsl:for-each select="quiz_response">
                <h3>
                    <xsl:value-of select="question_text" />
                </h3>

                <div>
                    <p>You answered: <xsl:value-of select="answer_response_text" /></p>
                </div>
            </xsl:for-each>
        </div>
        
    </xsl:template>
    
</xsl:stylesheet>
