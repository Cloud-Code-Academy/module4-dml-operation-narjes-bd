/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Narjes Dehkordi
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance
        Account apexCompany = new Account();

        // Set some fields on the Account
        apexCompany.Name = 'Apex Companyy';
        apexCompany.Website= 'www.apexCompany-narjes.com';
        apexCompany.NumberOfEmployees = 100;
        apexCompany.BillingCity='Berlin';

        // Insert the Account into the database
        Insert apexCompany;

        // Return the Id of the newly created Account
        return apexCompany.Id;
    }

    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline
        Account apexConsulting= new Account();
        apexConsulting.Name = name;
        apexConsulting.Industry = industry;

        // Insert the Account
        Insert apexConsulting;
    }

    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance
        Contact newContact = new Contact();

        // Set some fields on the Contact
        // Set the AccountId field to the given accountId
        newContact.AccountId = accountId;
        newContact.FirstName = 'Narjes';
        newContact.LastName = 'Dehkordi';
        newContact.Phone = '+49123123123';

        // Insert the Contact into the database
        Insert newContact;

        // Return the Id of the newly created Contact
        return newContact.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        Contact contactData= new Contact();
        contactData=[SELECT Id FROM Contact WHERE Id = :contactId];

        // Update the Contact's last name
        contactData.LastName = newLastName;

        // Update the Contact in the database
        Update contactData;
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        Opportunity oppData= new Opportunity();
        oppData=[SELECT Id FROM Opportunity WHERE Id = :oppId];

        // Update the Opportunity's stage
        oppData.StageName = newStage;

        // Update the Opportunity in the database
        Update oppData;
    }

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        Account accData = new Account();
        accData=[SELECT Id FROM Account WHERE Id = :accountId];
        accData.Name= newName;
        accData.Industry= newIndustry;

        // Update the Account with the given Id with the new name and industry
        Update accData;
    }


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        // Loop through each Opportunity in the list
            // Set the Opportunity's Stage to Qualification
            // Set the Opportunity's Close Date to 3 months from today
            // Set the Opportunity's Amount to 50000
        for (Opportunity opp: opportunities) {
            opp.StageName = 'Qualification';
            opp.CloseDate = Date.today().addMonths(3);
            opp.Amount = 50000;
        }
        Upsert opportunities;    
    }

    /**
     * Question 8
     * Insert or update opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * HINT: The account may or may not exists in the database but is required for opportunity creation. Consider how upsert operation can help with this.
     * HINT: There should not be duplicate opportunites based on the name
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        // Loop through each Opportunity name
            // Create an Opportunity with the given name
            // Add the Opportunity to the list
        Account accDataa;
        List<Account> accDataList = [SELECT Id, Name FROM Account WHERE Name = :accountName limit 1];
        if (accDataList.isEmpty()) {
            accDataa = new Account(Name = accountName);
            Insert accDataa;
        } else{ 
            accDataa = accDataList[0];
        }
        Set<String> nameSet = new Set<String>(OppNames);
        Map<String, Opportunity> existingOppsMap = new Map<String, Opportunity>();
        for (Opportunity opp :[SELECT Id, Name FROM Opportunity WHERE Name IN :nameSet]) {
            existingOppsMap.put(opp.Name,opp);
        } 
        List<Opportunity> oppLisToUpsert =  new List<Opportunity>();
        for (String name : oppNames) {
            Opportunity opp;
            If (existingOppsMap.containsKey(name))  {
                opp = existingOppsMap.get(name);
            } else {
                opp = new Opportunity();
                opp.Name = name;
                opp.StageName = 'Qualification';
                opp.CloseDate = Date.today().addMonths(3);
            }
            opp.AccountId = accDataa.Id;
            oppLisToUpsert.add(opp);
        }
        Upsert oppLisToUpsert;
            
    }
    
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		// Query for the Account
		List<Account> accounts = [SELECT Id FROM Account WHERE Name = :accountName];

		// if the Account exists, update the description
        Account acc;
        if (accounts.isEmpty()) {
            acc = new Account(Name = accountName);
            acc.Description = 'New Account';
            Insert acc;
        } else {
                acc = accounts[0];
                acc.Description = 'Updated Account';
                Update acc;
            }   
		return acc;
	}

    /**
     * Question 10
	 * Manage the association between Contacts and Accounts
	 * Ensure that for each Contact in the provided list, there is a corresponding Account Name that matches the Contact's last name.
	 * If such an Account does not exist, the method creates it; if it does, the method ensures the Contact is associated with it. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
     * Example Contact.LastName = 'Doe' Link to Account.Name = 'Doe' 
     * Example Contact.LastName = 'Jane' Link to Account.Name = 'Jane'
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
		List<Contact> contactsToUpdate = new List<Contact>();
        // Loop through each Contact
        // Extract the Account Name from Contact's LastName
        // Get the account based on the name or create one if it doesn't exist
        // Link the Contact to its Account using the Account Id
        // Upsert the Contacts
        for (Contact con : contactsToUpsert) {
            String accountName = con.LastName;
            Account acc = upsertAccount(accountName);
            con.AccountId = acc.Id;
            contactsToUpdate.add(con);
        }
        Upsert contactsToUpdate;
	}

    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        // Loop through each Lead name
        // Insert the Leads
        // Delete the Leads
        List<Lead> leadsToInsert = new List<Lead>();
        for (String leadName : leadNames) {
            Lead newLead = new Lead(LastName = leadName, Company = 'Test');
            leadsToInsert.add(newLead);
        }
        Insert leadsToInsert;
        Delete leadsToInsert;
    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
        // Insert the cases
        // Delete the cases
        List<Case> casesToInsert = new List<Case>();
        for (Integer i = 0; i < numOfCases;i++){
            Case newCase = new Case();
            newCase.AccountId = accountId;
            casesToInsert.add(newCase);
        }
        Insert casesToInsert;
        Delete casesToInsert;
    }
}