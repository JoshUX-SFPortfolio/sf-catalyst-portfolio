// Jest mock for lightning/navigation
const NavigationMixin = (Base) => {
    class NavigationMixinClass extends Base {
        [NavigationMixin.Navigate] = jest.fn();
        [NavigationMixin.GenerateUrl] = jest.fn(() => Promise.resolve('/mock-url'));
    }
    return NavigationMixinClass;
};

NavigationMixin.Navigate = Symbol('Navigate');
NavigationMixin.GenerateUrl = Symbol('GenerateUrl');

module.exports = { NavigationMixin };
