class Publishers::QuizzesController < Publishers::BaseController
  layout 'publishers', :except => [ :edit, :new ]
  skip_before_filter :verify_authenticity_token
  before_filter :authorize_site_admin_access
  
  def create
    @quiz = Quiz.create params[ :quiz ]
    
    respond_to do |wants|
      wants.html { redirect_to "/publishers/quizzes/show/#{@quiz.id}" and return }
    end
    
  end

  def destroy
    Quiz.destroy( params[ :id ] )
    flash[ :notice ] = "Quiz Deleted."
    redirect_to "/publishers/quizzes" and return
  end

  def edit
    @quiz = Quiz.find params[ :id ]
    @partners = [@quiz.partner]
  end

  def index
    if current_user.has_role? 'admin'
      @quiz_categories = QuizCategory.all(
        :include => { :partner_site_categories_quiz_categories => :quiz_category },
        :conditions => [ "quiz_categories.active = ?", true ]
      )

      @quizzes = Quiz.all(
        :conditions => [ "active = ?", true ],
        :include => :shared_quizzes
    )

    else
      @quiz_categories = QuizCategory.all(
        :include => { :partner_site_categories_quiz_categories => :quiz_category },
        :conditions => [ "quiz_categories.active = ? and (partner_id IS NULL or partner_id = ?)", true, current_user.partner.id ]
      )

      @quizzes = Quiz.all(
        :conditions => [ "active = ? and partner_id = ?", true, current_user.partner.id ],
        :include => :shared_quizzes
    )
    end
    
    @partner_sites = PartnerSite.all()    
    @quizzes = Quiz.all( :include => :shared_quizzes )
    
  end
  
  def new
    @quiz = Quiz.new
    quiz_category = QuizCategory.find params[:quiz_category_id]
    if current_user.has_role? 'admin'
      @partners = Partner.all
    else
      @partners = [current_user.partner]
    end
  end

  def update
    @quiz = Quiz.find params[ :id ]
    @quiz.update_attributes( params[ :quiz ])
    flash[ :notice ] = "You successfully updated your quiz."
    redirect_to "/publishers/quizzes/show/#{params[ :id ]}" and return
  end

  def show
    @quiz = Quiz.find( params[ :id ], :include => [ :quiz_phases, :quiz_recommendations ] )
    session[:quiz_div]={} if session[:quiz_div].nil?
    if (session[:quiz_div][params[:id].to_sym].nil?)
      session[:quiz_div][params[:id].to_sym]={}
      session[:quiz_div][params[:id].to_sym][:phases_div]={}
      session[:quiz_div][params[:id].to_sym][:questions_div]={}
    end
   end

  def tokens

    #stop_words = %w[ are as at be but by for if in into is it no not of on or such that the their then there these they this to was will with ]
    stop_words = YAML::load_file( 'util/harvester_stop_words.yml' )
    
    require 'xml/libxml'
    #include LibXML
    document = XML::Document.new
    document.root = Quiz.find( params[:id] ).to_solr_index_doc
    content = document.root.find( "//field[ @name = 'mlt_content' ]" ).first.content.gsub( /[^A-za-z0-9\s'-']/, "" ).downcase

    words = content.split( /\s/ )
    final_words = {}
    words.each do |w|
      unless stop_words.include? w
        final_words[ w ] = final_words[ w ] ? ( final_words[ w ] += 1 ) : 0
      end
    end

    @final_words = final_words.sort {|a,b| -1 * ( a[1] <=> b[1] ) }

    #root = index_doc.root
    #root << Quiz.find( params[ :id ] ).to_solr_index_doc
    #@url = URI.parse( 'http://localhost:8983/solr/analysis' )
    #@http = Net::HTTP.new( @url.host, @url.port )

    #response, body = @http.post( @url.path, index_doc.to_s, { 'Content-type'=>'text/xml; charset=utf-8' } )

    #parser = XML::Parser.string body
    #document = parser.parse
    #tokens = document.find '//token'
    #debugger
    #render :text => tokens.inspect
    render :partial => 'publishers/shared/tokens'
    #render :text => final_words.inspect
  end

  def toggle_phase
    session[:quiz_div][params[:quiz_id].to_sym][:quiz_phases_list] = get_enabled
  end

  def toggle_phase_quesion
    session[:quiz_div][params[:quiz_id].to_sym][:phases_div][params[:id].to_sym] = get_enabled
  end

  def toggle_phase_quesion_answer
    session[:quiz_div][params[:quiz_id].to_sym][:questions_div][params[:id].to_sym] = get_enabled
  end

  def toggle_recommendation
    session[:quiz_div][params[:quiz_id].to_sym][:recommendation] = get_enabled
  end

  def get_enabled
    enabled = ""
    unless params[:is_visible] == "true"
      enabled = "Enabled"
    end
    return enabled
  end

  def get_data
    @quiz = Quiz.find params[ :id ]
    @quiz_phases = QuizPhase.find_all_by_quiz_id(@quiz.id, :order => "position")


    respond_to do |format|
      format.csv {download_csv}
      format.pdf {download_pdf}
      format.rtf {download_rtf}
    end
  end


  private

  def download_csv
    require 'fastercsv'
        csv_header = ['Quiz Id','Quiz Name','Quiz Category','Quiz Description','Partner','Phase Name','Phase Position','Question',
          'Question Position','Answer Display Type','Answer','Answer Position','Answer Response Type', 'Value']
        csv_string = FasterCSV.generate do |csv|
          csv << csv_header
          @quiz_phases.each do |quiz_phase|
            @quiz_questions = QuizQuestion.find_all_by_quiz_phase_id(quiz_phase.id.to_i)
            @quiz_questions.each do |question|
              @quiz_answer = QuizAnswer.find_all_by_quiz_question_id(question.id.to_i)
              @quiz_answer.each do |answer|
                p "111111111111111111"
                p [quiz_phase.quiz_id, quiz_phase.quiz.name, quiz_phase.quiz.try(:quiz_category).try(:name), quiz_phase.quiz.description, quiz_phase.quiz.partner.name, quiz_phase.try(:name), quiz_phase.position, question.question, question.position, question.answer_display_type.display_type, answer.answer, answer.position, answer.	answer_response_type.response_type]
                csv << [quiz_phase.quiz_id, quiz_phase.quiz.try(:name), quiz_phase.quiz.try(:quiz_category).try(:name), quiz_phase.quiz.description,
                  quiz_phase.quiz.partner.name, quiz_phase.name, quiz_phase.position, question.question, question.position,
                  question.answer_display_type.display_type, answer.answer, answer.position, answer.	answer_response_type.response_type, answer.value]
              end
            end
          end
        end

    send_data csv_string, :type => "text/plain", :filename=>"#{@quiz.name}_Quiz-#{Time.now}.csv", :disposition => 'attachment'
  end

  def download_pdf
    require 'prawn'
    Prawn::Document.generate("#{RAILS_ROOT}/public/tmp/#{@quiz.name}_Quiz.pdf") do |pdf|
      pdf.define_grid(:columns => 5, :rows => 8, :gutter => 10)
      pdf.move_down 300

      pdf.fill_color "FF8888"
      pdf.text "#{@quiz.name}", :align => :center
      pdf.fill_color "000000"

      pdf.bounding_box([175, pdf.cursor], :width => 185, :height => 58) do
        pdf.image "public/images/Quiz-Special-BLEU_bandeau_quizz.jpg", :fit => [200, 200]
        pdf.stroke_bounds
      end

      @quiz_phases.each do |quiz_phase|
        @quiz_questions = QuizQuestion.find_all_by_quiz_phase_id(quiz_phase.id.to_i,  :order => "position")
        pdf.start_new_page
        pdf.grid([0.5,0], [7,4]).bounding_box do
          pdf.text "Phase Position: #{quiz_phase.position}"
        end

        pdf.grid([0.8,0], [7,4]).bounding_box do
          pdf.text "Phase Name:\n"
          pdf.text "\n #{quiz_phase.name}"
          pdf.text "\n"
          pdf.text " _ " * 40
        end
        pdf.grid([1.8,0], [7,4]).bounding_box do
          pdf.text "\n"
          pdf.text "Phase Description:\n"
          pdf.text "\n #{quiz_phase.description}"
          pdf.text "\n"
          pdf.text " _ " * 40
          pdf.text "\n"
        end

        @quiz_questions.each_with_index do |question, index|
          @quiz_answer = QuizAnswer.find_all_by_quiz_question_id(question.id.to_i, :order => "position")


          pdf.text "#{index+1}.   #{question.question}"
          pdf.text "_"*40
          pdf.text "\n"


          @quiz_answer.each_with_index do |answer, index|
            pdf.text " - #{answer.answer}       =>      #{answer.value}\n"

          end
          pdf.text "\n"
        end
      end

      pdf.start_new_page

      pdf.fill_color "FF8888"
      pdf.text "Quiz Recommendations", :align => :center
      pdf.fill_color "000000"

      pdf.text "\n"
      pdf.text "\n"
      pdf.text "\n"
      pdf.text "\n"

      @quiz_recommendations = QuizRecommendation.find_all_by_quiz_id(@quiz.id.to_i)
      @quiz_recommendations.each do |recommendation|
        pdf.text "\n"
        pdf.text "\n"
        pdf.text "Recommendation Name:       #{recommendation.name} \n"
        pdf.text "Score Range:     #{recommendation.value_floor}-#{recommendation.value_ceiling} \n"
        pdf.text "Recommendation: \n"
        pdf.text recommendation.recommendation.gsub(%r{</?[^>]+?>}, '')
        pdf.text "\n"
        pdf.start_new_page
      end

    end
#    send_data "#{RAILS_ROOT}/public/#{@quiz.name}_Quiz.pdf", :type => 'application/pdf', :disposition => 'attachment'
      send_file("#{RAILS_ROOT}/public/tmp/#{@quiz.name}_Quiz.pdf", :filename => "#{@quiz.name}_Quiz.pdf", :type => "application/pdf")
  end

  def download_rtf
    require 'rtf'
    styles = {}
    styles['PS_HEADING']              = RTF::ParagraphStyle.new
    styles['PS_NORMAL']               = RTF::ParagraphStyle.new
#    styles['PS_NORMAL'].justification = RTF::ParagraphStyle::FULL_JUSTIFY
    styles['PS_INDENTED']             = RTF::ParagraphStyle.new
    styles['PS_INDENTED'].left_indent = 300
    styles['PS_TITLE']                = RTF::ParagraphStyle.new
    styles['PS_TITLE'].space_before   = 100
    styles['PS_TITLE'].space_after    = 200
    styles['CS_HEADING']              = RTF::CharacterStyle.new
    styles['CS_HEADING'].bold         = true
    styles['CS_HEADING'].font_size    = 36
    styles['CS_CODE']                 = RTF::CharacterStyle.new
#    styles['CS_CODE'].font            = RTF::fonts[1]
    styles['CS_CODE'].font_size       = 16

    
    document = RTF::Document.new(RTF::Font.new(RTF::Font::ROMAN, 'Times New Roman'))
    
    document.paragraph do |p|
       p.apply(styles['CS_HEADING']) do |s|
          s << @quiz.name
          s.line_break
          s << " _ " * 20
          s.line_break
       end
    end

    document.page_break

#    document.image("public/images/Quiz-Special-BLEU_bandeau_quizz.jpg")

    @quiz_phases.each do |quiz_phase|
        @quiz_questions = QuizQuestion.find_all_by_quiz_phase_id(quiz_phase.id.to_i,  :order => "position")
        document.paragraph(styles['PS_TITLE']) do |p|
           p << "Phase Position: #{quiz_phase.position}"
        end
        document.paragraph(styles['PS_NORMAL']) do |p|
           p.bold << "Phase Name:"
           p.line_break
           p << "#{quiz_phase.name}"
           p.line_break
           p << " _ " * 30
           p.line_break
        end
        document.paragraph(styles['PS_NORMAL']) do |p|
           p.bold << "Phase Description:"
           p.line_break
           p << "#{quiz_phase.description}"
           p.line_break
           p << " _ " * 30
           p.line_break
        end

        document.page_break

      @quiz_questions.each_with_index do |question, index|
        @quiz_answer = QuizAnswer.find_all_by_quiz_question_id(question.id.to_i, :order => "position")

        document.paragraph(styles['PS_NORMAL']) do |p|
          p.bold << "#{index+1}. #{question.question}"
          p.line_break
          p << "\n"
        end

        @quiz_answer.each_with_index do |answer, index|
          document.paragraph(styles['PS_NORMAL']) do |p|
            p << "- #{answer.answer}    =>      #{answer.value}"
            p.line_break
          end
        end
        
      end
       document.page_break
    end


    document.paragraph(styles['PS_NORMAL']) do |p|
            p.bold << "Quiz Recommendations"
            p.line_break
            p << " _ " * 30
            p.line_break
          end

    @quiz_recommendations = QuizRecommendation.find_all_by_quiz_id(@quiz.id.to_i)
    @quiz_recommendations.each do |recommendation|
      document.paragraph(styles['PS_NORMAL']) do |p|
            p << "Recommendation Name:       #{recommendation.name}"
            p.line_break
            p << "Score Range:     #{recommendation.value_floor}-#{recommendation.value_ceiling}"
            p.line_break
            p << "Recommendation:"
            p.line_break
            p << recommendation.recommendation.gsub(%r{</?[^>]+?>}, '')
            p.line_break
            document.page_break
          end
    end
    

    File.open("#{RAILS_ROOT}/public/tmp/#{@quiz.name}_Quiz.doc", 'a+') {|file| file.write(document.to_rtf)}

    send_file("#{RAILS_ROOT}/public/tmp/#{@quiz.name}_Quiz.doc", :filename => "#{@quiz.name}_Quiz.doc", :type=>"text/richtext")
#    File.delete("#{RAILS_ROOT}/#{@quiz.name}_Quiz-#{Time.now}.doc")
  end

end
