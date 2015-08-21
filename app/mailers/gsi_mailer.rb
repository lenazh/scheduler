# This mailer sends out the newly generated passwords
# for GSIs that have been just enrolled into a class
class GsiMailer < ActionMailer::Base
  default from: 'zhivun@gmail.com'

  def new_gsi_enrollment(course, gsi)
    enrollment course, gsi
  end

  def existing_gsi_enrollment(course, gsi)
    enrollment course, gsi
  end

  private

  def enrollment(course, gsi)
    @gsi = gsi
    @course = course
    @head_gsi = course.user
    @password = gsi.password
    url = ActionMailer::Base.default_url_options
    @hostname = "http://#{url[:host]}"
    mail to: @gsi.email,
         subject: "Teaching #{course.name}",
         from: @head_gsi.email
  end
end
