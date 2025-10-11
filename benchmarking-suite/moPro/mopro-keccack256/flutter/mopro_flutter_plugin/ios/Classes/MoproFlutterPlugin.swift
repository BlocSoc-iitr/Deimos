import Flutter
import Foundation
import UIKit

class FlutterG1 {
  let x: String
  let y: String
  let z: String

  init(x: String, y: String, z: String) {
    self.x = x
    self.y = y
    self.z = z
  }
}

class FlutterG2 {
  let x: [String]
  let y: [String]
  let z: [String]

  init(x: [String], y: [String], z: [String]) {
    self.x = x
    self.y = y
    self.z = z
  }
}

class FlutterCircomProof {
  let a: FlutterG1
  let b: FlutterG2
  let c: FlutterG1
  let `protocol`: String
  let curve: String

  init(a: FlutterG1, b: FlutterG2, c: FlutterG1, `protocol`: String, curve: String) {
    self.a = a
    self.b = b
    self.c = c
    self.`protocol` = `protocol`
    self.curve = curve
  }
}

class FlutterCircomProofResult {
  let proof: FlutterCircomProof
  let inputs: [String]

  init(proof: FlutterCircomProof, inputs: [String]) {
    self.proof = proof
    self.inputs = inputs
  }
}

func convertCircomProof(res: CircomProofResult) -> [String: Any] {
  let g1a = FlutterG1(x: res.proof.a.x, y: res.proof.a.y, z: res.proof.a.z)
  let g2b = FlutterG2(x: res.proof.b.x, y: res.proof.b.y, z: res.proof.b.z)
  let g1c = FlutterG1(x: res.proof.c.x, y: res.proof.c.y, z: res.proof.c.z)
  let circomProof = FlutterCircomProof(
    a: g1a, b: g2b, c: g1c, `protocol`: res.proof.protocol, curve: res.proof.curve)
  let circomProofResult = FlutterCircomProofResult(proof: circomProof, inputs: res.inputs)
  let resultMap: [String: Any] = [
    "proof": [
      "a": [
        "x": circomProofResult.proof.a.x,
        "y": circomProofResult.proof.a.y,
        "z": circomProofResult.proof.a.z,
      ],
      "b": [
        "x": circomProofResult.proof.b.x,
        "y": circomProofResult.proof.b.y,
        "z": circomProofResult.proof.b.z,
      ],
      "c": [
        "x": circomProofResult.proof.c.x,
        "y": circomProofResult.proof.c.y,
        "z": circomProofResult.proof.c.z,
      ],
      "protocol": circomProofResult.proof.protocol,
      "curve": circomProofResult.proof.curve,
    ],
    "inputs": circomProofResult.inputs,
  ]
  return resultMap
}

func convertCircomProofResult(proof: [String: Any]) -> CircomProofResult {
  let proofMap = proof["proof"] as! [String: Any]
  let aMap = proofMap["a"] as! [String: String]
  let g1a = G1(x: aMap["x"] ?? "0", y: aMap["y"] ?? "0", z: aMap["z"] ?? "1")
  let bMap = proofMap["b"] as! [String: [String]]
  let g2b = G2(
    x: bMap["x"] ?? ["1", "0"], y: bMap["y"] ?? ["1", "0"], z: bMap["z"] ?? ["1", "0"])
  let cMap = proofMap["c"] as! [String: String]
  let g1c = G1(x: cMap["x"] ?? "0", y: cMap["y"] ?? "0", z: cMap["z"] ?? "1")
  let circomProof = CircomProof(
    a: g1a, b: g2b, c: g1c, `protocol`: proofMap["protocol"] as! String,
    curve: proofMap["curve"] as! String)
  let circomProofResult = CircomProofResult(
    proof: circomProof, inputs: proof["inputs"] as! [String])
  return circomProofResult
}

public class MoproFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "mopro_flutter", binaryMessenger: registrar.messenger())
    let instance = MoproFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "generateCircomProof":
      guard let args = call.arguments as? [String: Any],
        let zkeyPath = args["zkeyPath"] as? String,
        let inputs = args["inputs"] as? String,
        let proofLib = args["proofLib"] as? Int
      else {
        result(
          FlutterError(
            code: "ARGUMENT_ERROR", message: "Missing arguments \(call.arguments)", details: nil))
        return
      }

      do {
        var moproProofLib: ProofLib
        if proofLib == 0 {
          moproProofLib = ProofLib.arkworks
        } else {
          moproProofLib = ProofLib.rapidsnark
        }
        // Call the function from mopro.swift
        let proofResult = try generateCircomProof(
          zkeyPath: zkeyPath, circuitInputs: inputs, proofLib: moproProofLib)
        let resultMap = convertCircomProof(res: proofResult)

        // Return the proof and inputs as a map supported by the StandardMethodCodec
        result(resultMap)
      } catch {
        result(
          FlutterError(
            code: "PROOF_GENERATION_ERROR", message: "Failed to generate proof",
            details: error.localizedDescription))
      }

    case "verifyCircomProof":
      guard let args = call.arguments as? [String: Any],
        let zkeyPath = args["zkeyPath"] as? String,
        let proof = args["proof"] as? [String: Any],
        let proofLib = args["proofLib"] as? Int
      else {
        result(FlutterError(code: "ARGUMENT_ERROR", message: "Missing arguments \(call.arguments)", details: nil))
        return
      }

      do {
        var moproProofLib: ProofLib
        if proofLib == 0 {
          moproProofLib = ProofLib.arkworks
        } else {
          moproProofLib = ProofLib.rapidsnark
        }
        let circomProofResult = convertCircomProofResult(proof: proof)
        // Call the function from mopro.swift
        let valid = try verifyCircomProof(
          zkeyPath: zkeyPath, proofResult: circomProofResult, proofLib: moproProofLib)

        // Return the proof and inputs as a map supported by the StandardMethodCodec
        result(valid)
      } catch {
        result(
          FlutterError(
            code: "PROOF_VERIFICATION_ERROR", message: "Failed to verify proof",
            details: error.localizedDescription))
      }

    case "generateHalo2Proof":
      guard let args = call.arguments as? [String: Any],
        let srsPath = args["srsPath"] as? String,
        let pkPath = args["pkPath"] as? String,
        let inputs = args["inputs"] as? [String: [String]]
      else {
        result(FlutterError(code: "ARGUMENT_ERROR", message: "Missing arguments", details: nil))
        return
      }

      do {
        let proofResult = try generateHalo2Proof(
          srsPath: srsPath, pkPath: pkPath, circuitInputs: inputs)
        let resultMap = [
          "proof": proofResult.proof,
          "inputs": proofResult.inputs,
        ]
        result(resultMap)
      } catch {
        result(
          FlutterError(
            code: "PROOF_GENERATION_ERROR", message: "Failed to generate proof",
            details: error.localizedDescription))
      }

    case "verifyHalo2Proof":
      guard let args = call.arguments as? [String: Any],
        let srsPath = args["srsPath"] as? String
      else {
        result(
          FlutterError(code: "ARGUMENT_ERROR", message: "Missing arguments srsPath", details: nil))
        return
      }

      guard let args = call.arguments as? [String: Any],
        let vkPath = args["vkPath"] as? String
      else {
        result(
          FlutterError(code: "ARGUMENT_ERROR", message: "Missing arguments vkPath", details: nil))
        return
      }

      guard let args = call.arguments as? [String: Any],
        let proof = args["proof"] as? FlutterStandardTypedData
      else {
        result(
          FlutterError(code: "ARGUMENT_ERROR", message: "Missing arguments proof", details: nil))
        return
      }

      guard let args = call.arguments as? [String: Any],
        let inputs = args["inputs"] as? FlutterStandardTypedData
      else {
        result(
          FlutterError(code: "ARGUMENT_ERROR", message: "Missing arguments inputs", details: nil))
        return
      }

      do {
        let valid = try verifyHalo2Proof(
          srsPath: srsPath, vkPath: vkPath, proof: proof.data, publicInput: inputs.data)
        result(valid)
      } catch {
        result(
          FlutterError(
            code: "PROOF_VERIFICATION_ERROR", message: "Failed to verify proof",
            details: error.localizedDescription))
      }
    case "generateNoirProof":
      guard let args = call.arguments as? [String: Any],
        let circuitPath = args["circuitPath"] as? String,
        let inputs = args["inputs"] as? [String],
        let onChain = args["onChain"] as? Bool,
        let vk = args["vk"] as? FlutterStandardTypedData,
        let lowMemoryMode = args["lowMemoryMode"] as? Bool
      else {
        result(FlutterError(code: "ARGUMENT_ERROR", message: "Missing arguments", details: nil))
        return
      }

      let srsPath = args["srsPath"] as? String

      do {
        let proofResult = try generateNoirProof(
          circuitPath: circuitPath, srsPath: srsPath, inputs: inputs, onChain: onChain, vk: vk.data, lowMemoryMode: lowMemoryMode)
        result(proofResult)
      } catch {
        result(
          FlutterError(
            code: "PROOF_GENERATION_ERROR", message: "Failed to generate proof",
            details: error.localizedDescription))
      }

    case "verifyNoirProof":
      guard let args = call.arguments as? [String: Any],
        let circuitPath = args["circuitPath"] as? String,
        let proof = args["proof"] as? FlutterStandardTypedData,
        let onChain = args["onChain"] as? Bool,
        let vk = args["vk"] as? FlutterStandardTypedData,
        let lowMemoryMode = args["lowMemoryMode"] as? Bool
      else {
        result(FlutterError(code: "ARGUMENT_ERROR", message: "Missing arguments", details: nil))
        return
      }

      do {
        let valid = try verifyNoirProof(circuitPath: circuitPath, proof: proof.data, onChain: onChain, vk: vk.data, lowMemoryMode: lowMemoryMode)
        result(valid)
      } catch {
        result(
          FlutterError(
            code: "PROOF_VERIFICATION_ERROR", message: "Failed to verify proof",
            details: error.localizedDescription))
      }
    case "getNoirVerificationKey":
      guard let args = call.arguments as? [String: Any],
        let circuitPath = args["circuitPath"] as? String,
        let onChain = args["onChain"] as? Bool,
        let lowMemoryMode = args["lowMemoryMode"] as? Bool
      else {
        result(FlutterError(code: "ARGUMENT_ERROR", message: "Missing arguments", details: nil))
        return
      }

      let srsPath = args["srsPath"] as? String

      do {
        let vkResult = try getNoirVerificationKey(circuitPath: circuitPath, srsPath: srsPath, onChain: onChain, lowMemoryMode: lowMemoryMode)
        result(vkResult)
      } catch {
        result(
          FlutterError(
            code: "VK_GENERATION_ERROR", message: "Failed to generate verification key",
            details: error.localizedDescription))
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
