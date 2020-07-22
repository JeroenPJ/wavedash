import { Controller } from "stimulus"

import { createCubeKeyframes } from '../cubemath'

const animationDuration = 1200

export default class extends Controller {
  static targets = [ 'cubeContainer', 'frontSide' ]

  connect () {
    if (false && process.env.NODE_ENV === 'development') {
      if (!window.keyFramesCreated) {
        createCubeKeyframes()
        window.keyFramesCreated = true
      }
    }
  }

  onRender (event) {
    if (window.previousFrontSide) {
      this.rotateToNewContent(window.previousFrontSide)

      window.previousFrontSide = null
    }
  }

  onBeforeVisit (event) {
    window.previousFrontSide = this.getFrontSide().innerHTML.toString()
  }

  getCubeContainer = () => document.querySelector('#cube-container')
  getFrontSide = () => document.querySelector('#cube .front .side-inner')

  rotateToNewContent (oldContent) {
    const frontSide = this.getFrontSide()
    if (frontSide) {
      const content = frontSide.innerHTML
      frontSide.innerHTML = oldContent
      setTimeout(() => {
        this.rotate()
      }, 10)

      setTimeout(() => {
        frontSide.innerHTML = content
      }, animationDuration / 2)
    }
  }

  rotate () {
    const container = this.getCubeContainer()
    container.classList.add('rotating')
    setTimeout(() => {
      container.classList.remove('rotating')
    }, animationDuration)
  }
}