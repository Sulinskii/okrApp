//
//  Retry+Additions.swift
//  AppOKR
//
//  Created by Artur Sulinski on 13/03/2022.
//

import Combine

//extension Publisher {
//    func retry<T: Scheduler>(
//        _ retries: Int,
//        delay: T.SchedulerTimeType.Stride,
//        scheduler: T
//    ) -> AnyPublisher<Output, Failure> {
//        self.catch { _ in
//            Just(())
//                .delay(for: delay, scheduler: scheduler)
//                .flatMap { _ in self }
//                .retry(retries > 0 ? retries - 1 : 0)
//        }
//        .eraseToAnyPublisher()
//    }
//}
