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
    let info1 = ComponentInfo(name: "Intervals and chords", composition: composition_IntervalsAndChords(), deepLink: .intervalsAndChords)
    let info2 = ComponentInfo(name: "This is a test", composition: ExampleCompositions.randomComposition, deepLink: .test)
    return [info1, info2]
}

private func composition_IntervalsAndChords() -> Composition {
    
    let composition = Composition()
    
    repeated(times: 20) {
           let bar = Bar()
           let sequence = NoteSequence()
           sequence.add(note: Note(value: .crotchet, pitch: .f3))
           sequence.add(note: Note(value: .crotchet, pitch: .f3))
           sequence.add(note: Note(value: .crotchet, pitch: .f3))
           sequence.add(note: Note(value: .crotchet, pitch: .f3))
           bar.add(sequence: sequence)
           composition.add(bar: bar)
       }
    
    // Intervals
    do {
        let bar = Bar()
        let sequence = NoteSequence()
        sequence.add(note: Note(value: .crotchet, pitches: [.c4, .g3]))
        sequence.add(note: Note(value: .crotchet, pitches: [.d4, .a4]))
        sequence.add(note: Note(value: .crotchet, pitches: [.d4, .f3]))
        sequence.add(note: Note(value: .crotchet, pitches: [.e4, .g3]))
        bar.add(sequence: sequence)
        composition.add(bar: bar)
    }
    
    // Intervals (wider)
    do {
        let bar = Bar()
        let sequence = NoteSequence()
        sequence.add(note: Note(value: .crotchet, pitches: [.e4, .e3]))
        sequence.add(note: Note(value: .crotchet, pitches: [.f4, .f3]))
        sequence.add(note: Note(value: .crotchet, pitches: [.d3, .f4]))
        sequence.add(note: Note(value: .crotchet, pitches: [.f2, .c5]))
        bar.add(sequence: sequence)
        composition.add(bar: bar)
    }
    
    // Connected intervals
    do {
        let bar = Bar()
        let sequence = NoteSequence()
        sequence.add(note: Note(value: .quaver, pitches: [.f3, .a4]))
        sequence.add(note: Note(value: .quaver, pitches: [.d4, .f4]))
        bar.add(sequence: sequence)
        composition.add(bar: bar)
    }
    
    // Connected intervals
    do {
        let bar = Bar()
        let sequence = NoteSequence()
        sequence.add(note: Note(value: .quaver, pitches: [.c3, .g3]))
        sequence.add(note: Note(value: .quaver, pitches: [.e4, .g4]))
        bar.add(sequence: sequence)
        composition.add(bar: bar)
    }
    
    // Equidistant intervals
    do {
        let bar = Bar()
        let sequence = NoteSequence()
        sequence.add(note: Note(value: .crotchet, pitches: [.c4, .a4]))
        sequence.add(note: Note(value: .crotchet, pitches: [.d4, .g3]))
        sequence.add(note: Note(value: .crotchet, pitches: [.e4, .f3]))
        sequence.add(note: Note(value: .crotchet, pitches: [.f4, .e3]))
        sequence.add(note: Note(value: .crotchet, pitches: [.g4, .d3]))
        sequence.add(note: Note(value: .crotchet, pitches: [.a5, .c3]))
        sequence.add(note: Note(value: .crotchet, pitches: [.b5, .b3]))
        sequence.add(note: Note(value: .crotchet, pitches: [.c5, .a3]))
        sequence.add(note: Note(value: .crotchet, pitches: [.d5, .g4]))
        sequence.add(note: Note(value: .crotchet, pitches: [.e5, .f4]))
        bar.add(sequence: sequence)
        composition.add(bar: bar)
    }
    
    // Chords
    do {
        let bar = Bar()
        let sequence = NoteSequence()
        sequence.add(note: Note(value: .crotchet, pitches: [.a5, .a4, .f3, .d3]))
        sequence.add(note: Note(value: .crotchet, pitches: [.e4, .c4, .d3]))
        bar.add(sequence: sequence)
        composition.add(bar: bar)
    }
    
    // Chords
    do {
        let bar = Bar()
        let sequence = NoteSequence()
        sequence.add(note: Note(value: .crotchet, pitches: [.e4, .c4, .f3]))
        sequence.add(note: Note(value: .crotchet, pitches: [.g4, .d4, .b4, .d3]))
        sequence.add(note: Note(value: .crotchet, pitches: [.a5, .e3, .c3]))
        sequence.add(note: Note(value: .crotchet, pitches: [.e3, .a4, .f4]))
        bar.add(sequence: sequence)
        composition.add(bar: bar)
    }
    
    // Chords - Equidistant notes from center
    do {
        let bar = Bar()
        let sequence = NoteSequence()
        sequence.add(note: Note(value: .crotchet, pitches: [.f3, .a4, .c4, .e4]))
        sequence.add(note: Note(value: .crotchet, pitches: [.d3, .b4, .g4]))
        sequence.add(note: Note(value: .crotchet, pitches: [.c3, .g3, .d4, .a5]))
        sequence.add(note: Note(value: .minim, pitches: [.e3, .g3, .d4, .f4]))
        bar.add(sequence: sequence)
        composition.add(bar: bar)
    }
    
    // Chords - Equidistant notes from center
    do {
        let bar = Bar()
        let sequence = NoteSequence()
        sequence.add(note: Note(value: .quaver, pitches: [.a4, .c4, .e4]))
        sequence.add(note: Note(value: .quaver, pitches: [.f3, .a4, .c4]))
        sequence.add(note: Note(value: .quaver, pitches: [.g3, .b4, .d4]))
        bar.add(sequence: sequence)
        composition.add(bar: bar)
    }
    
    // TEST
    
    repeated(times: 20) {
        let bar = Bar()
        let sequence = NoteSequence()
        sequence.add(note: Note(value: .crotchet, pitch: .f3))
        sequence.add(note: Note(value: .crotchet, pitch: .f3))
        sequence.add(note: Note(value: .crotchet, pitch: .f3))
        sequence.add(note: Note(value: .crotchet, pitch: .f3))
        bar.add(sequence: sequence)
        composition.add(bar: bar)
    }
    
    repeated(times: 20) {
        let bar = Bar()
        let sequence = NoteSequence()
        sequence.add(note: Note(value: .crotchet, pitch: .f5))
        sequence.add(note: Note(value: .crotchet, pitch: .f5))
        sequence.add(note: Note(value: .crotchet, pitch: .f5))
        sequence.add(note: Note(value: .crotchet, pitch: .f5))
        bar.add(sequence: sequence)
        composition.add(bar: bar)
    }
    
    repeated(times: 20) {
        let bar = Bar()
        let sequence = NoteSequence()
        sequence.add(note: Note(value: .crotchet, pitch: .a2))
        sequence.add(note: Note(value: .crotchet, pitch: .a2))
        sequence.add(note: Note(value: .crotchet, pitch: .a2))
        sequence.add(note: Note(value: .crotchet, pitch: .a2))
        bar.add(sequence: sequence)
        composition.add(bar: bar)
    }
    
    return composition
}
