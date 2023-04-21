//
//  ScanNationIdViewController.swift
//  sathapana-mobile-app
//
//  Created by Sovanndy Ul on 31/3/21.
//

import UIKit
import AVFoundation

protocol TakeNationIdPhotoDelegate: AnyObject {
    func image(with image: UIImage?, customerName: String?, birthDate: Date?, gender: String?, identifierValue: String?)
}

class ScanNationIdViewController: BaseViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var mrzScannerView: QKMRZScannerView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var manualInputLabel: UILabel!
    @IBOutlet weak var takePhotoButton: CameraButton!
    @IBOutlet weak var takePhotoCornorImageView: UIImageView!

    var imageCapture: UIImage!
    var timer = Timer()
    var totalSecond: Int!
    var delegate: TakeNationIdPhotoDelegate!

    // MARK: - View Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        ImagePickerManager.shared.requestCameraPermission { (isGranted) in
            guard isGranted == true else {
                ImagePickerManager.shared.alertPhotoLibraryNotEnable()
                self.totalSecond = 0
                return
            }
        }
        totalSecond = 30
        setupView()
        scheduledTimer()
        manualInputLabel.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        mrzScannerView.isTakePhotoClicked = false
        mrzScannerView.startScanning()
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mrzScannerView.stopScanning()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func scheduledTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(updateTime),
                                     userInfo: nil,
                                     repeats: true)
    }

    private func invalidate() {
        timer.invalidate()
    }

    private func setupView() {
        takePhotoCornorImageView.isHidden = true
        takePhotoButton.isHidden = true
        mrzScannerView.delegate = self

        titleLabel.text = "scan_nation_id".localizedString
        titleLabel.font = .fontBold(size: 20)

        descriptionLabel.text = "scan_nation_id_description".localizedString
        descriptionLabel.font = .fontNormal(size: 14)

        manualInputLabel.font = .fontNormal(size: 17)

        takePhotoButton.setTitle("take_photo_and_manual_input".localizedString, for: .normal)
        takePhotoButton.titleLabel?.font = .fontNormal(size: 14)
        takePhotoButton.layer.cornerRadius = 8

        adjustBackButton()
    }

    func adjustBackButton() {
        backButton.contentMode = .scaleAspectFit
        backButton.backgroundColor = .white
        backButton.layer.cornerRadius = 8
        backButton.layer.borderColor = UIColor.borderGray.cgColor
        backButton.layer.borderWidth = 1
        backButton.layer.shadowColor = UIColor.borderGray.cgColor
        backButton.layer.shadowOpacity = 1
        backButton.layer.shadowOffset = .zero
        backButton.layer.shadowRadius = 2
        backButton.setTitle(emptyString, for: .normal)
        backButton.addTarget(nil, action: #selector(backButtonDidTap), for: .touchUpInside)
    }

    // MARK: - QKMRZScannerViewDelegate
    @IBAction func takePhotoDidTap() {
        mrzScannerView.isTakePhotoClicked = true
    }

    @objc func updateTime() {
        if totalSecond != 0 {
            totalSecond -= 1
            if totalSecond == 0 {
                manualInputLabel.isHidden = true
            } else {
                manualInputLabel.isHidden = false
            }
        } else {
            takePhotoCornorImageView.isHidden = false
            takePhotoButton.isHidden = false
            invalidate()
        }

        let fullAttributedString = NSMutableAttributedString()
        let attributedLinkString = NSMutableAttributedString(string: "scan_national_id_card_manual_input".localizedString,
                                                             attributes: [
                                                                .font: UIFont.fontBold(size: 14),
                                                                .foregroundColor: UIColor.white
                                                             ])
        let fullString = String(format: "scan_national_id_card_manual_input_second".localizedString, totalSecond)
        let secondAttributedString = NSMutableAttributedString(string: fullString,
                                                              attributes: [
                                                                .font: UIFont.fontBold(size: 14),
                                                                .foregroundColor: UIColor.white])
        fullAttributedString.append(attributedLinkString)
        fullAttributedString.append(secondAttributedString)
        manualInputLabel.attributedText = fullAttributedString
    }

    @objc func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - QKMRZScannerViewDelegate
extension ScanNationIdViewController: QKMRZScannerViewDelegate {
    func mrzScannerView(_ mrzScannerView: QKMRZScannerView, didFind scanResult: QKMRZScanResult) {
        let name = scanResult.surnames + " " + scanResult.givenNames
        delegate.image(with: scanResult.documentImage, customerName:
                        name, birthDate: scanResult.birthDate, gender: scanResult.sex, identifierValue: scanResult.documentNumber)
        self.navigationController?.popViewController(animated: true)
    }

    func mrzScannerView(_ mrzScannerView: QKMRZScannerView, didFind image: UIImage) {
        delegate.image(with: image, customerName: nil, birthDate: nil, gender: nil, identifierValue: nil)
        self.navigationController?.popViewController(animated: true)
    }
}
