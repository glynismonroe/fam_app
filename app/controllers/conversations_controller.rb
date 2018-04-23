class ConversationsController < ApplicationController 
   before_action :authenticate_user!
  # before_action :get_mailbox
   before_action :get_conversation, except: [:index]
  
  
  
  
  def index 
    @conversations = current_user.mailbox.conversations 
  end 

  def show 
    @conversation = current_user.mailbox.conversations.find(params[:id])
  end 
    
  def new 
    @recipients = User.all - [current_user]
  end 
    
    def create 
    recipient = User.find(params[:user_id])
    receipt = current_user.send_message(recipient, params[:body], params[:subject])
    redirect_to conversation_path(receipt.conversation)
    end 
    
  def empty_trash
    @mailbox.trash.each do |conversation|
    conversation.receipts_for(current_user).update_all(deleted: true)
  end
   flash[:success] = 'Your trash was cleaned!'
   redirect_to conversations_path
  end

  def mark_as_read
    @conversation.mark_as_read(current_user)
    flash[:success] = 'The conversation was marked as read.'
    redirect_to conversations_path
  end
    
  def show
        
  end
    
      private
    
      def get_conversation
        @conversation ||= @mailbox.conversations.find(params[:id])
      
      end
    
  def reply
    current_user.reply_to_conversation(@conversation, params[:body])
    flash[:success] = 'Reply sent'
    redirect_to conversation_path(@conversation)
  end
    
    # before_action :get_box, only: [:index]
  
  def index
    if @box.eql? "inbox"
      @conversations = @mailbox.inbox
    elsif @box.eql? "sent"
      @conversations = @mailbox.sentbox
    else
      @conversations = @mailbox.trash
    end
  
    @conversations = @conversations.paginate(page: params[:page], per_page: 10)
  end
  
  private
  
  def get_box
    if params[:box].blank? or !["inbox","sent","trash"].include?(params[:box])
      params[:box] = 'inbox'
    end
    @box = params[:box]
  end
  
  # before_action :authenticate_user!
  # before_action :get_mailbox
  # before_action :get_conversation, except: [:index]
  # before_action :get_box, only: [:index]
  
  def destroy
    @conversation.move_to_trash(current_user)
    flash[:success] = 'The conversation was moved to trash.'
    redirect_to conversations_path
  end
  
  def restore
    @conversation.untrash(current_user)
    flash[:success] = 'The conversation was restored.'
    redirect_to conversations_path
  end
    
    
  # before_action :get_conversation, except: [:index, :empty_trash]


  
#   before_filter :authenticate_user!
#   before_filter :get_mailbox, :get_box, :get_actor
#   before_filter :check_current_subject_in_conversation, :only => [:show, :update, :destroy]

#   def index
#     if @box.eql? "inbox"
#       @conversations = @mailbox.inbox.page(params[:page]).per(9)
#     elsif @box.eql? "sentbox"
#       @conversations = @mailbox.sentbox.page(params[:page]).per(9)
#     else
#       @conversations = @mailbox.trash.page(params[:page]).per(9)
#     end

#     respond_to do |format|
#       format.html { render @conversations if request.xhr? }
#     end
#   end

#   def show
#     if @box.eql? 'trash'
#       @receipts = @mailbox.receipts_for(@conversation).trash
#     else
#       @receipts = @mailbox.receipts_for(@conversation).not_trash
#     end
#     render :action => :show
#     @receipts.mark_as_read
#   end

#   def update
#     if params[:untrash].present?
#     @conversation.untrash(@actor)
#     end

#     if params[:reply_all].present?
#       last_receipt = @mailbox.receipts_for(@conversation).last
#       @receipt = @actor.reply_to_all(last_receipt, params[:body])
#     end

#     if @box.eql? 'trash'
#       @receipts = @mailbox.receipts_for(@conversation).trash
#     else
#       @receipts = @mailbox.receipts_for(@conversation).not_trash
#     end
#     redirect_to :action => :show
#     @receipts.mark_as_read

#   end

#   def destroy

#     @conversation.move_to_trash(@actor)

#     respond_to do |format|
#       format.html {
#         if params[:location].present? and params[:location] == 'conversation'
#           redirect_to conversations_path(:box => :trash)
# 	else
#           redirect_to conversations_path(:box => @box,:page => params[:page])
# 	end
#       }
#       format.js {
#         if params[:location].present? and params[:location] == 'conversation'
#           render :js => "window.location = '#{conversations_path(:box => @box,:page => params[:page])}';"
# 	else
#           render 'conversations/destroy'
# 	end
#       }
#     end
#   end

#   private

#   def get_mailbox
#     @mailbox = current_actor.mailbox
#   end

#   def get_actor
#     @actor = Actor.normalize(current_subject)
#   end

#   def get_box
#     if params[:box].blank? or !["inbox","sentbox","trash"].include?params[:box]
#       params[:box] = 'inbox'
#     end

#     @box = params[:box]
#   end

#   def check_current_subject_in_conversation
#     @conversation = Conversation.find_by_id(params[:id])

#     if @conversation.nil? or !@conversation.is_participant?(@actor)
#       redirect_to conversations_path(:box => @box)
#     return
#     end
#   end

end
