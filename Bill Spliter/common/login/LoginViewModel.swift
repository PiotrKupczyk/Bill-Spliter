//
// Created by Piotr Kupczyk on 25/10/2019.
// Copyright (c) 2019 Piotr Kupczyk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    private let bag = DisposeBag()

    struct UIInputs {
        let loginTriggered: Observable<Void>
        let loginTypingTriggered: Observable<String>
        let passwordTypingTriggered: Observable<String>
    }

    private let login = BehaviorRelay<String>(value: "")
    private let password = BehaviorRelay<String>(value: "")

    // Outputs
    let authSuccessfully = PublishSubject<Void>()

    init(inputs: UIInputs) {

        inputs.loginTriggered
                .throttle(1, scheduler: MainScheduler.instance)
                .subscribe(onNext: {
                    print("Login taped...")
                    self.authenticate()
                }).disposed(by: bag)

        inputs.loginTypingTriggered
                .throttle(1, scheduler: MainScheduler.instance)
                .bind(to: login)
                .disposed(by: bag)

        inputs.passwordTypingTriggered
                .throttle(1, scheduler: MainScheduler.instance)
                .bind(to: password)
                .disposed(by: bag)
    }

    func authenticate() {
        AuthenticationService.authenticate(self.login.value, self.password.value) { response in
            guard let tokenResponse = response else {
                // here handle failed auth
                print("Auth failed")
                return
            }
            let defaults = UserDefaults.standard
            defaults.set(tokenResponse.token, forKey: Const.TOKEN_KEY)
            print("Authorized successfully, token [\(tokenResponse.token)]")
            self.authSuccessfully.onNext(())

        }
    }

}
