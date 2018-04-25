class MessagesController < ApplicationController
  before_action :set_conversation
  respond_to :html, :js

  def create
    receipt = current_user.reply_to_conversation(@conversation, body)
    redirect_to receipt.conversation
  end

  private

  def set_conversation
    @conversation = current_user.mailbox.conversations.find(params[:conversation_id])
  end

  #   before_filter :authenticate_user!
  #   before_filter :get_mailbox, :get_box, :get_actor
  def index
    redirect_to conversations_path(box: @box)
  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
    if (@message = Message.find_by_id(params[:id])) && (@conversation = @message.conversation)
      if @conversation.is_participant?(@actor)
        redirect_to conversation_path(@conversation, box: @box, anchor: 'message_' + @message.id.to_s)
        return
      end
    end
    redirect_to conversations_path(box: @box)
  end

  # GET /messages/new
  # GET /messages/new.xml
  def new
    if params[:receiver].present?
      @recipient = Actor.find_by_slug(params[:receiver])
      return if @recipient.nil?
      @recipient = nil if Actor.normalize(@recipient) == Actor.normalize(current_subject)
    end
  end

  # GET /messages/1/edit
  def edit; end

  # POST /messages
  # POST /messages.xml
  def create
    @recipients =
      if params[:_recipients].present?
        @recipients = params[:_recipients].split(',').map { |r| Actor.find(r) }
      else
        []
      end

    @receipt = @actor.send_message(@recipients, params[:body], params[:subject])
    if @receipt.errors.blank?
      @conversation = @receipt.conversation
      flash[:success] = t('mailboxer.sent')
      redirect_to conversation_path(@conversation, box: :sentbox)
    else
      render action: :new
    end
  end

  # PUT /messages/1
  # PUT /messages/1.xml
  def update; end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy; end

  private

  def get_mailbox
    @mailbox = current_subject.mailbox
  end

  def get_actor
    @actor = Actor.normalize(current_subject)
  end

  def get_box
    if params[:box].blank? || !%w[inbox sentbox trash].include?(params[:box])
      @box = 'inbox'
      return
    end
    @box = params[:box]
  end

  def new; end

  def create
    recipients = User.where(id: params['recipients'])
    conversation = current_user.send_message(recipients, params[:message][:body], params[:message][:subject]).conversation
    flash[:success] = 'Message has been sent!'
    redirect_to conversation_path(conversation)
  end
end

def new
  @chosen_recipient = User.find_by(id: params[:to].to_i) if params[:to]
end
