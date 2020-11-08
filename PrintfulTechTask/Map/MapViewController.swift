//
//  ViewController.swift
//  PrintfulTechTask
//
//  Created by pavels.vetlugins on 07/11/2020.
//

import UIKit


class MapViewController: UIViewController {

    var interactor: MapInteractor!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.interactor = MapInteractor()
        self.interactor.connect()

    }
}

