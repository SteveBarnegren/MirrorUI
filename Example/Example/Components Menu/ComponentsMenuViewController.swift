//
//  ComponentsMenuViewController.swift
//  Example
//
//  Created by Steve Barnegren on 22/03/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import UIKit
import MusicNotationKit

struct ComponentInfo {
    let name: String
    let composition: Composition
    let deepLink: ComponentDeepLink
}

private let cellIdentifier = "DefaultCell"

class ComponentsMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var tableView: UITableView!
    private let componentInfos = makeComponentInfos()
    private let deepLink: ComponentDeepLink?
    
    init(deepLink: ComponentDeepLink?) {
        self.deepLink = deepLink
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: .zero)
        self.tableView.allowsMultipleSelection = false
        view.addSubview(self.tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        handleDeepLink()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.indexPathsForSelectedRows?.forEach { tableView.deselectRow(at: $0, animated: true) }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return componentInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let info = componentInfos[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = info.name
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = componentInfos[indexPath.row]
        showComponent(info: info)
    }
    
    // MARK: - Navigation
    
    private func showComponent(info: ComponentInfo) {
        let vc = ScrollingMusicExampleViewController(composition: info.composition)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - DeepLink
    
    private func handleDeepLink() {
        
        guard let deepLink = self.deepLink else {
            return
        }
        
        guard let info = self.componentInfos.first(where: { $0.deepLink == deepLink }) else {
            return
        }
        
        showComponent(info: info)
    }
}

private func makeComponentInfos() -> [ComponentInfo] {
    let notes = ComponentInfo(name: "Notes", composition: ComponentCompositions.notes, deepLink: .notes)
    let rests = ComponentInfo(name: "Rests", composition: ComponentCompositions.rests, deepLink: .rests)
    let intervals = ComponentInfo(name: "Intervals and chords", composition: ComponentCompositions.intervalsAndChords, deepLink: .intervalsAndChords)
    let accidentals = ComponentInfo(name: "Accidentals", composition: ComponentCompositions.accidentals, deepLink: .accidentals)

    return [notes, rests, intervals, accidentals]
}
