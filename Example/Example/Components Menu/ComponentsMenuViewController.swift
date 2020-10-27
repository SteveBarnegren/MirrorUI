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
}

private let cellIdentifier = "DefaultCell"

class ComponentsMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var deeplink: Deeplink?
    
    private var tableView: UITableView!
    private let componentInfos = makeComponentInfos()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: .zero)
        self.tableView.allowsMultipleSelection = false
        view.addSubview(self.tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.indexPathsForSelectedRows?.forEach { tableView.deselectRow(at: $0, animated: true) }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleDeeplink()
    }
    
    // MARK: - Deeplinking
    
    private func handleDeeplink() {
        
        guard let path = deeplink?.nextPathComponent() else {
            return
        }
        
        func sanitise(_ string: String) -> String {
            var s = string
            s.removeAll(where: { $0 == " " })
            return s.lowercased()
        }
        
        for component in componentInfos {
            if sanitise(component.name) == sanitise(path) {
                showComponent(info: component)
                return
            }
        }
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
        vc.title = info.name
        navigationController?.pushViewController(vc, animated: true)
    }
}

private func makeComponentInfos() -> [ComponentInfo] {
    let notes = ComponentInfo(name: "Notes", composition: ComponentCompositions.notes)
    let rests = ComponentInfo(name: "Rests", composition: ComponentCompositions.rests)
    let intervals = ComponentInfo(name: "Intervals and chords", composition: ComponentCompositions.intervalsAndChords)
    let adjacentNoteChords = ComponentInfo(name: "Adjacent note chords", composition: ComponentCompositions.adjacentNoteChords)
    let accidentals = ComponentInfo(name: "Accidentals", composition: ComponentCompositions.accidentals)
    let ties = ComponentInfo(name: "Ties", composition: ComponentCompositions.ties)
    let accents = ComponentInfo(name: "Accents", composition: ComponentCompositions.accents)

    return [notes, rests, intervals, adjacentNoteChords, accidentals, ties, accents]
}
