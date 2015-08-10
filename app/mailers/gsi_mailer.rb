# This mailer sends out the newly generated passwords
# for GSIs that have been just enrolled into a class
class GsiMailer < ActionMailer::Base
  default from: 'zhivun@gmail.com'

  def enrollment(course, gsi)
    @gsi = gsi
    @course = course
    @head_gsi = course.user
    @password = gsi.password
    # TODO: Fix the URL
    url = ActionMailer::Base.default_url_options
    @hostname = "http://#{url[:host]}"
    mail to: @gsi.email, subject: "Teaching #{course.name}"
  end
end
