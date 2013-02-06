<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:output method="html" />

    <xsl:param name="previous_page_uri" />
    <xsl:param name="resume_uri" />

    <!-- TODO customize transformation rules
         syntax recommendation http://www.w3.org/TR/xslt
    -->
    <xsl:template match="/">

        <html>
            <head>
                <title>Quiz Catalog</title>
            </head>
            <body>
                <xsl:apply-templates select="//quiz_request"/>
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
                <xsl:value-of select="'[]'" />
            </xsl:attribute>
            <xsl:attribute name="type">
                <xsl:value-of select="type" />
            </xsl:attribute>
            <xsl:attribute name="value">
                <xsl:value-of select="value" />
            </xsl:attribute>
            <xsl:if test="../existing_answer">
                <xsl:attribute name="checked">
                    <xsl:value-of select="'CHECKED'" />
                </xsl:attribute>
            </xsl:if>
        </input>
        <xsl:apply-templates select="text_post_parameter_suboption" />
    </xsl:template>

    <xsl:template match="text_post_parameter_suboption">
        <xsl:choose>
            <xsl:when test="type/text()='textarea'">
                <textarea>
                    <xsl:attribute name="name">
                        <xsl:value-of select="name" />
                    </xsl:attribute>
                    <xsl:attribute name="rows">
                        <xsl:value-of select="rows" />
                    </xsl:attribute>
                    <xsl:attribute name="cols">
                        <xsl:value-of select="cols" />
                    </xsl:attribute>
                    <xsl:if test="../free_text_answer">
                        <xsl:value-of select="../free_text_answer" />
                    </xsl:if>
                </textarea>
            </xsl:when>
            <xsl:otherwise>
                <input>
                    <xsl:attribute name="type">
                        <xsl:value-of select="type" />
                    </xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="name" />
                    </xsl:attribute>
                    <xsl:attribute name="size">
                        <xsl:value-of select="size" />
                    </xsl:attribute>
                    <xsl:attribute name="maxlength">
                        <xsl:value-of select="maxlength" />
                    </xsl:attribute>
                    <xsl:attribute name="value">
                        <xsl:value-of select="free_text_answer" />
                    </xsl:attribute>
                </input>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="quiz_request">
        <div>
            <h2>
                <xsl:value-of select="quiz_request_metadata/name" />
            </h2>
            <xsl:if test="quiz_request_metadata/resume_quiz_uri">
                <a href="{$resume_uri}">Resume This Quiz</a>
            </xsl:if>
            <xsl:if test="quiz_phase/errors/error/message">
                <div class="errorExplanation" id="errorExplanation" style="color: #600;">
                    <h4>Please correct the following problems:</h4>
                    <ul style="margin-left: 25px;">
                        <li>
                            <xsl:value-of select="quiz_phase/errors/error/message" />
                        </li>
                    </ul>
                </div>
            </xsl:if>
            <form method="POST" action="/quizzes/{quiz_request_metadata/quiz_instance_uuid}/submit">

                <input type="hidden" name="submit_to">
                    <xsl:attribute name="value">
                        <xsl:value-of select="quiz_request_metadata/quiz_response_uri" />
                    </xsl:attribute>
                </input>

                <input type="hidden" name="user_id" value="1234" />
                <xsl:apply-templates select="quiz_metadata/post_parameter" />

                <xsl:apply-templates select="quiz_phase/quiz_question" />

                <xsl:if test="$previous_page_uri != ''">
                    <a href="{$previous_page_uri}" style="margin-right: 10px;">&lt; Back</a>
                </xsl:if>
                <input type="submit" value="Continue &gt;" />
            </form>

        </div>
        <br/>
    </xsl:template>
</xsl:stylesheet>
