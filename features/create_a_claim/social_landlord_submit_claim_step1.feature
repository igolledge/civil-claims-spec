Feature: Social Landlord, Submit Claim, Step 1

  @happypath
  Scenario: Create a new claim, with personal details
    Given I am logged in as a Social Landlord
    When I visit '/claims/new'
    And fill in the form with my personal details
    And and no validation errors have occurred
    And I click the 'Continue to next step' button
    Then I expect to be redirected to the claim page
    And my details to be present on the page

  Scenario: Create a new claim, property postcode lookup
    Given I am logged as a Social Landlord
    And I visit the starting page of the claim form
    And I enter a valid postcode in the Property section
    And press the "Fink UK address" button
    Then I expect to see a dropdown menu appear
    And the property address can be selected in the menu

  Scenario: Create a new claim, address from property postcode
    Given I am logged as a Social Landlord
    And I visit the starting page of the claim form
    And I enter a valid postcode in the Property section
    And press the "Fink UK address" button
    And select the property address in the dropdown
    Then I expect that the street address and town will be shown
    And I'm able to modify them

  Scenario: Create a new claim, landlord postcode lookup
    Given I am logged as a Social Landlord
    And I visit the starting page of the claim form
    And I enter a valid postcode in the Landlord Details section
    And press the "Fink UK address" button
    Then I expect to see a dropdown menu appear
    And the landlord's address can be selected in the menu

  Scenario: Create a new claim, address from landlord's postcode
    Given I am logged as a Social Landlord
    And I visit the starting page of the claim form
    And I enter a valid postcode in the Landlord section
    And press the "Fink UK address" button
    And select the landlord address in the drop-down
    Then I expect that the street address and town will be shown
    And I'm able to modify them    

  Scenario: Create a new claim, enter a title number
    Given I am logged as a Social Landlord
    And I visit the starting page of the claim form
    And I click on "Would you like to provide a title number?"
    Then I expect to see an input field appear 
    That lets me enter a title number

  Scenario: Create a new claim, enter DX in landlord address
    Given I am logged as a Social Landlord
    And I visit the starting page of the claim form
    And I click on "Would you like to provide a DX number?"
    Then I expect to see two input fields appear
    That lets me enter a DX number and a DX exchange



    

  @validations
  Scenario Outline: Character length validation
    When I visit '/claims/new'
    And I am filling in the step1 <formitem>
    And I enter the <text>
    Then I expect it to <validate>
    And return the <message>

    Examples:
    | formitem       | text | validate | message                                         |
    | landlord-email | abc  | fail     | Email address must be in format name@server.com |
    | tenant-email   | abc  | fail     | Email address must be in format name@server.com |
    | postcode       | abc  | fail     | This is not a valid postcode                    |

  Scenario Outline: Radio buttons validation
    Given I am logged as a Social Landlord
    And I visit the starting page of the claim form
    And I click on "Continue to next step"
    And I don't select any choice for <choice>
    Then I expect it to fail
    And return the <message>

    Examples:
    | choice                    | message                                    |
    | "Who is in the Property?" | "You must indicate who is in the property" |
    | "Address"                 | "You must indicate where the tenants are"  |


  @ia
  Scenario Outline: Access control
    Given a new claim with a Property, Landlord and Tenant
    And I authenticate as a <Role>
    When I try to <Action> this claim
    Then I expect my request to <Outcome>

    Examples:
    | Role     | Action   | Outcome |
    | claimant | retrieve | succeed |
    | claimant | update   | succeed |
    | claimant | delete   | succeed |
    | tenant   | retrieve | fail    |
    | tenant   | update   | fail    |
    | tenant   | delete   | fail    |

  @performance
  Scenario: Creating a claim under load
    Given there are 100 concurrent users of the system
    When they each create a claim
    Then I expect page response times to remain under 200ms

  @performance
  Scenario: Retrieving a claim under load
    Given there are 1000 concurent users of the system
    When they all retrieve a claim
    Then I expect page response times to remain under 5ms