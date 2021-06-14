//
//  CameraStuff.swift
//  Clima
//
//  Created by Zion Tuiasoa on 12/31/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit

//MARK: Camera Related Enums
enum FilmSpeed {
    case _200
    case _400
    case _800
}

enum Aperature {
    case f2_8
    case f3_2
    case f4_6
}

enum Subject {
    case pikachu
    case charmander
    case squirtle
}

enum CameraType {
    case cannon
    case nikon
    case sony
}

struct Camera {
    var subject: Subject
    var filmSpeed: FilmSpeed
    var aperature: Aperature

    var shutterCompletion: ()->()?

    func shutterClicked() {
        shutterCompletion()
    }
}

//MARK: Camera listener methods
protocol CameraDelegate: AnyObject {
    func shutterClicked()
}

protocol FilmDelegate: AnyObject {
    var exposuresLeft: Int? { get }
    var filmRollsLeft: Int? { get }
    func filmSpeedChanged(to speed: FilmSpeed)
}

protocol AdvancedCameraDelegate: CameraDelegate, FilmDelegate {
    var isTooLateToShoot: Bool? { get set }
    func aperatureChanged(to aperature: Aperature)
    func subjectInFocus(with subject: Subject)
}

//MARK: Camera has the delegate (I am the customer)
class CameraBrain {

    var camera: Camera?
    weak var cameraDelegate: AdvancedCameraDelegate?

    init(with cameraType: CameraType) {
        setupCamera(with: cameraType)
    }

    func setupCamera(with cameraType: CameraType) {
        switch cameraType {
        case .cannon:
            camera = Camera(subject: .charmander, filmSpeed: ._200, aperature: .f2_8, shutterCompletion: {
                self.cameraDelegate?.shutterClicked()
            })
        case .nikon:
            camera = Camera(subject: .pikachu, filmSpeed: ._400, aperature: .f3_2, shutterCompletion: {
                self.cameraDelegate?.shutterClicked()
            })
        case .sony:
            camera = Camera(subject: .squirtle, filmSpeed: ._800, aperature: .f4_6, shutterCompletion: {
                self.cameraDelegate?.shutterClicked()
            })
        }
    }


    func focusCamera(on subject: Subject) {
        cameraDelegate?.subjectInFocus(with: subject)
    }

    func changeAperature(to aperature: Aperature) {
        // if camera isn't active return, else change aperature
        cameraDelegate?.aperatureChanged(to: aperature)
    }
}

//MARK: Conforms to delegate (I am the barista)
class RockGymViewController: UIViewController, AdvancedCameraDelegate {

    var isTooLateToShoot: Bool?
    var exposuresLeft: Int?
    var filmRollsLeft: Int?

    var brain: CameraBrain?

    override func viewDidLoad() {
        super.viewDidLoad()

        brain?.cameraDelegate = self
    }

    @IBAction func userCameraSelected() {
        // some logic to discern the selection

        let tempSelection: CameraType = .cannon
        brain = CameraBrain(with: tempSelection)
    }

    func shutterClicked() {
        // make an alert that says: "NICE SHOT DUUUUUDE!!!!"
        print()
    }

    func aperatureChanged(to aperature: Aperature) {

    }

    func subjectInFocus(with subject: Subject) {

    }

    func filmSpeedChanged(to speed: FilmSpeed) {

    }
}

class WaterGymViewController: UIViewController, CameraDelegate, FilmDelegate {

    var exposuresLeft: Int?
    var filmRollsLeft: Int?

    func filmSpeedChanged(to speed: FilmSpeed) {

    }

    func shutterClicked() {

    }
}

class MainMenuViewController: UIViewController, FilmDelegate {

    var exposuresLeft: Int?
    var filmRollsLeft: Int?

    func filmSpeedChanged(to speed: FilmSpeed) {

    }
}
