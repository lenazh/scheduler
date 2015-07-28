# Preview of the enrollment email with fake users
class GsiMailerPreview < ActionMailer::Preview
  # I don't know how to access Rspec mocks from here
  # Fake user that knows just enough methods to render
  # an email
  class FakeUser
    attr_accessor :name
    def initialize(name)
      self.name = name
    end

    def email
      "#{name.split(/ /).last.downcase}@example.com"
    end

    def password
      'password'
    end
  end

  # Fake course that knows just enough methods to render
  # an email
  class FakeCourse
    attr_accessor :name, :user
    def initialize(name, owner)
      self.name = name
      self.user = owner
    end
  end

  def enrollment
    owner = FakeUser.new 'Darth Vader'
    course = FakeCourse.new 'Cat Throwing Fall 2015', owner
    gsi = FakeUser.new 'Luke Skywalker'

    GsiMailer.enrollment(course, gsi)
  end
end
