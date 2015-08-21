module GsiHelpers
  # enrolls a gsi for the course given email and hours
  # if the GSI is not already enrolled
  def create_gsi(email, hours)
    @gsi = {}
    @gsi[:email] = email
    @gsi[:hours] = hours
    click_link 'GSIs'
    within('#gsi-roster') do
      if page.has_content? email
        return
      else
        create_gsi_do(email, hours)
      end
    end
  end

  # enrolls a gsi for the course given email and hours
  def create_gsi_do(email, hours)
    fill_in 'email', with: email
    fill_in 'hours', with: hours
    click_button 'Add'
    expect(page).to have_content email
  end

  # returns id of the employment record for the selected course given gsi hash
  def employment_id(gsi)
    email = gsi[:email]
    within('#gsi-roster') do
      return find('td', text: email)['id'].match(/gsi-email-(\d+)/)[1]
    end
  end
end

World(GsiHelpers)
