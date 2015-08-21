module CourseHelpers
  # returns id of the class owned by user given name
  def owned_class_id(name)
    within('#owned-classes') do
      return find_button(name)['id'].match(/owned-class-(\d+)/)[1]
    end
  end

  # creates a new class given name
  def create_class(name)
    @class = name
    click_link 'My Classes'
    within('#owned-classes') do
      if page.has_content? name
        return
      else
        fill_in 'name', with: name
        click_button 'Add'
      end
    end
  end
end

World(CourseHelpers)
