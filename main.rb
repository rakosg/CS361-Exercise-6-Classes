# Exercise 6

class LaunchDiscussionWorkflow

    def initialize(discussion, host, participants)
      @discussion = discussion
      @host = host
      @participants = participants
    end
  
    # Expects @participants array to be filled with User objects
    def run(participants)
      return unless valid?
      run_callbacks(:create) do
        ActiveRecord::Base.transaction do
          discussion.save!
          create_discussion_roles!
          @successful = true
        end
      end
end

class ParticipantsUsingEmailStrings

    attr_reader :participants_email_string, :participants

    def initialize(participants_email_string)
        @participants_email_string = participants_email_string
    end

    def generate_participant_users_from_email_string(participants)
      return if @participants_email_string.blank?
      participants_email_string.split.uniq.map do |email_address|
        User.create(email: email_address.downcase, password: Devise.friendly_token)
      end
    end
  
    # ...
  
end
  
discussion = Discussion.new(title: "fake", ...)
host = User.find(42)
participants = "fake1@example.com\nfake2@example.com\nfake3@example.com"

userGenerator = ParticipantsUsingEmailStrings.new(participants)
participants = userGenerator.generate_users
workflow = LaunchDiscussionWorkflow.new(discussion, host, participants)
workflow.run(participants)
  