//
//  Sounds.swift
//  Redead
//
//  Created by Labuser on 8/1/16.
//  Copyright © 2016 Matthew Genova. All rights reserved.
//

import Foundation
import AVFoundation

class Sounds{
    
    /*
    *  SOUND STUFF
    *
    *
    */
    
    let deathMusic = "Assets/Death Is Just Another Path_0"
    let deathMusicExt = "mp3"
    let dungeonMusic = "Assets/A_Journey_Awaits"
    let dungeonMusicExt = "mp3"
    let bossMusic = "Assets/boss_theme"
    let bossMusicExt = "mp3"
    
    
    
    func setBackgroundMusic(_ musicPath: String, ofType: String)
    {
        let backgroundSound = URL(fileURLWithPath: Bundle.main.path(forResource: musicPath, ofType: ofType)!)
        var backgroundAudioPlayer : AVAudioPlayer?
        
        do {
            backgroundAudioPlayer = try AVAudioPlayer(contentsOf: backgroundSound)
        }
        catch
        {
            backgroundAudioPlayer = nil
        }
        backgroundAudioPlayer!.numberOfLoops = -1
        backgroundAudioPlayer!.volume = 0.3
        backgroundAudioPlayer!.prepareToPlay()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: {
            backgroundAudioPlayer!.play()
        })
    }
    
    let hitSound = "Assets/Hit"
    let hitSoundExt = "wav"
    let deathSound = "Assets/gameOverSound"
    let deathSoundExt = "mp3"
    let zombieDeathSound = "Assets/zombieDeathSoundQuestionMark"
    let zombieDeathSoundExt = "mp3"
    
    func playTempSound(_ soundPath: String, ofType: String)
    {
        let tempSound = URL(fileURLWithPath: Bundle.main.path(forResource: soundPath, ofType: ofType)!)
        var tempAudioPlayer : AVAudioPlayer?
        
        do {
            tempAudioPlayer = try AVAudioPlayer(contentsOf: tempSound)
        }
        catch
        {
            tempAudioPlayer = nil
        }
        print(tempAudioPlayer)
        if tempAudioPlayer != nil && !tempAudioPlayer!.isPlaying{
            tempAudioPlayer!.prepareToPlay()
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: {
                tempAudioPlayer!.play()
            })
        }
        
    }
    
}
