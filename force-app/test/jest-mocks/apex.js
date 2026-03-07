// Jest mock for @salesforce/apex imports
// Returns a jest.fn() so each test can configure its own resolved/rejected value
const apex = new Proxy(
    {},
    {
        get(target, name) {
            return jest.fn();
        }
    }
);

module.exports = apex;
