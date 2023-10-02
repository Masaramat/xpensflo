require "application_system_test_case"

class DebitCreditsTest < ApplicationSystemTestCase
  setup do
    @debit_credit = debit_credits(:one)
  end

  test "visiting the index" do
    visit debit_credits_url
    assert_selector "h1", text: "Debit credits"
  end

  test "should create debit credit" do
    visit debit_credits_url
    click_on "New debit credit"

    click_on "Create Debit credit"

    assert_text "Debit credit was successfully created"
    click_on "Back"
  end

  test "should update Debit credit" do
    visit debit_credit_url(@debit_credit)
    click_on "Edit this debit credit", match: :first

    click_on "Update Debit credit"

    assert_text "Debit credit was successfully updated"
    click_on "Back"
  end

  test "should destroy Debit credit" do
    visit debit_credit_url(@debit_credit)
    click_on "Destroy this debit credit", match: :first

    assert_text "Debit credit was successfully destroyed"
  end
end
