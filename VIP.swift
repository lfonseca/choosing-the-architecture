//
//  Created by Lucas Fonseca and Giovane Possebon
//  Source: http://clean-swift.com/clean-swift-ios-architecture/
//

import UIKit

struct Person { // Entity (usually more complex e.g. NSManagedObject)
    let firstName: String
    let lastName: String
}

struct GreetingData { // Transport data structure (not Entity)
    let greeting: String
    let subject: String
}

protocol GreetingViewControllerInput: class {
    func setGreeting(greeting: String)
}

protocol GreetingViewControllerOutput {
    func fetchGreetingData()
}

class GreetingViewController : UIViewController, GreetingViewControllerInput {
    let showGreetingButton = UIButton()
    let greetingLabel = UILabel()

    var output: GreetingViewControllerOutput!

    override func viewDidLoad() {
        super.viewDidLoad()
        showGreetingButton.addTarget(self, action: "didTapButton:", forControlEvents: .TouchUpInside)
    }

    func didTapButton(button: UIButton) {
        output.fetchGreetingData()
    }

    func setGreeting(greeting: String) {
        greetingLabel.text = greeting
    }

    // layout code goes here
}

protocol GreetingInteractorInput {
    func fetchGreetingData()
}

protocol GreetingInteractorOutput {
    func presentGreetingData(greetingData: GreetingData)
}

class GreetingInteractor : GreetingInteractorInput {
    weak var output: GreetingInteractorOutput!

    func fetchGreetingData() {
        let person = Person(firstName: "David", lastName: "Blaine") // usually comes from data access layer
        let subject = person.firstName + " " + person.lastName
        let greeting = GreetingData(greeting: "Hello", subject: subject)
        output.presentGreetingData(greeting)
    }
}

protocol GreetingPresenterInput {
    func presentGreetingData(greetingData: GreetingData)
}

protocol GreetingPresenterOutput {
    func setGreeting(greeting: String)
}

class GreetingPresenter : GreetingPresenterInput {
    var output: GreetingPresenterOutput!

    func presentGreetingData(greetingData: GreetingData) {
        let greeting = greetingData.greeting + " " + greetingData.subject
        output.setGreeting(greeting)
    }
}

// Assembling of VIP scene, without Router
let view = GreetingViewController()
let presenter = GreetingPresenter()
let interactor = GreetingInteractor()
view.output = interactor
interactor.output = presenter
presenter.output = view
