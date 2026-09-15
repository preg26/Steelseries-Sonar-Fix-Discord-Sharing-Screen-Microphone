# ============================================================
# MUTE DISCORD / STEELSERIES SONAR MICROPHONE
#
# - Cible le cote RENDER du peripherique Sonar Microphone
# - Mute uniquement la session audio Discord correspondante
# - Surveille en permanence toutes les 5 secondes
# - Si Discord redemarre ou si sa session est recreee,
#   elle sera automatiquement mutee a nouveau
# ============================================================

$TargetDevice  = "SteelSeries Sonar - Microphone"
$TargetProcess = "Discord"
$CheckInterval = 5


Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
using System.Diagnostics;
using System.Collections.Generic;

namespace CoreAudio
{
    public enum EDataFlow
    {
        eRender = 0,
        eCapture = 1,
        eAll = 2
    }

    [Flags]
    public enum DEVICE_STATE : uint
    {
        ACTIVE = 0x00000001
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct PROPERTYKEY
    {
        public Guid fmtid;
        public uint pid;
    }

    [StructLayout(LayoutKind.Explicit)]
    public struct PROPVARIANT
    {
        [FieldOffset(0)]
        public ushort vt;

        [FieldOffset(8)]
        public IntPtr pointerValue;

        public string GetString()
        {
            if (vt == 31 && pointerValue != IntPtr.Zero)
                return Marshal.PtrToStringUni(pointerValue);

            return null;
        }
    }

    [ComImport]
    [Guid("BCDE0395-E52F-467C-8E3D-C4579291692E")]
    public class MMDeviceEnumerator
    {
    }

    [ComImport]
    [Guid("A95664D2-9614-4F35-A746-DE8DB63617E6")]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    public interface IMMDeviceEnumerator
    {
        int EnumAudioEndpoints(
            EDataFlow dataFlow,
            DEVICE_STATE dwStateMask,
            out IMMDeviceCollection ppDevices);

        int GetDefaultAudioEndpoint(
            EDataFlow dataFlow,
            int role,
            out IMMDevice ppEndpoint);

        int GetDevice(
            [MarshalAs(UnmanagedType.LPWStr)] string pwstrId,
            out IMMDevice ppDevice);

        int RegisterEndpointNotificationCallback(IntPtr pClient);

        int UnregisterEndpointNotificationCallback(IntPtr pClient);
    }

    [ComImport]
    [Guid("0BD7A1BE-7A1A-44DB-8397-CC5392387B5E")]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    public interface IMMDeviceCollection
    {
        int GetCount(out uint pcDevices);

        int Item(
            uint nDevice,
            out IMMDevice ppDevice);
    }

    [ComImport]
    [Guid("D666063F-1587-4E43-81F1-B948E807363F")]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    public interface IMMDevice
    {
        int Activate(
            ref Guid iid,
            uint dwClsCtx,
            IntPtr pActivationParams,
            [MarshalAs(UnmanagedType.IUnknown)] out object ppInterface);

        int OpenPropertyStore(
            uint stgmAccess,
            out IPropertyStore ppProperties);

        int GetId(
            [MarshalAs(UnmanagedType.LPWStr)] out string ppstrId);

        int GetState(out uint pdwState);
    }

    [ComImport]
    [Guid("886D8EEB-8CF2-4446-8D02-CDBA1DBDCF99")]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    public interface IPropertyStore
    {
        int GetCount(out uint cProps);

        int GetAt(
            uint iProp,
            out PROPERTYKEY pkey);

        int GetValue(
            ref PROPERTYKEY key,
            out PROPVARIANT pv);

        int SetValue(
            ref PROPERTYKEY key,
            ref PROPVARIANT propvar);

        int Commit();
    }

    [ComImport]
    [Guid("77AA99A0-1BD6-484F-8BC7-2C654C9A9B6F")]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    public interface IAudioSessionManager2
    {
        int GetAudioSessionControl(
            IntPtr AudioSessionGuid,
            uint StreamFlags,
            out IntPtr SessionControl);

        int GetSimpleAudioVolume(
            IntPtr AudioSessionGuid,
            uint StreamFlags,
            out IntPtr AudioVolume);

        int GetSessionEnumerator(
            out IAudioSessionEnumerator SessionEnum);

        int RegisterSessionNotification(IntPtr SessionNotification);
        int UnregisterSessionNotification(IntPtr SessionNotification);

        int RegisterDuckNotification(
            [MarshalAs(UnmanagedType.LPWStr)] string sessionID,
            IntPtr duckNotification);

        int UnregisterDuckNotification(IntPtr duckNotification);
    }

    [ComImport]
    [Guid("E2F5BB11-0570-40CA-ACDD-3AA01277DEE8")]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    public interface IAudioSessionEnumerator
    {
        int GetCount(out int SessionCount);

        int GetSession(
            int SessionCount,
            out IAudioSessionControl Session);
    }

    [ComImport]
    [Guid("F4B1A599-7266-4319-A8CA-E70ACB11E8CD")]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    public interface IAudioSessionControl
    {
        int GetState(out int pRetVal);

        int GetDisplayName(
            [MarshalAs(UnmanagedType.LPWStr)] out string pRetVal);

        int SetDisplayName(
            [MarshalAs(UnmanagedType.LPWStr)] string Value,
            IntPtr EventContext);

        int GetIconPath(
            [MarshalAs(UnmanagedType.LPWStr)] out string pRetVal);

        int SetIconPath(
            [MarshalAs(UnmanagedType.LPWStr)] string Value,
            IntPtr EventContext);

        int GetGroupingParam(out Guid pRetVal);

        int SetGroupingParam(
            ref Guid Override,
            IntPtr EventContext);

        int RegisterAudioSessionNotification(IntPtr NewNotifications);
        int UnregisterAudioSessionNotification(IntPtr NewNotifications);
    }

    [ComImport]
    [Guid("BFB7FF88-7239-4FC9-8FA2-07C950BE9C6D")]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    public interface IAudioSessionControl2
    {
        int GetState(out int pRetVal);

        int GetDisplayName(
            [MarshalAs(UnmanagedType.LPWStr)] out string pRetVal);

        int SetDisplayName(
            [MarshalAs(UnmanagedType.LPWStr)] string Value,
            IntPtr EventContext);

        int GetIconPath(
            [MarshalAs(UnmanagedType.LPWStr)] out string pRetVal);

        int SetIconPath(
            [MarshalAs(UnmanagedType.LPWStr)] string Value,
            IntPtr EventContext);

        int GetGroupingParam(out Guid pRetVal);

        int SetGroupingParam(
            ref Guid Override,
            IntPtr EventContext);

        int RegisterAudioSessionNotification(IntPtr NewNotifications);
        int UnregisterAudioSessionNotification(IntPtr NewNotifications);

        int GetSessionIdentifier(
            [MarshalAs(UnmanagedType.LPWStr)] out string pRetVal);

        int GetSessionInstanceIdentifier(
            [MarshalAs(UnmanagedType.LPWStr)] out string pRetVal);

        int GetProcessId(out uint pRetVal);

        int IsSystemSoundsSession();

        int SetDuckingPreference(bool optOut);
    }

    [ComImport]
    [Guid("87CE5498-68D6-44E5-9215-6DA47EF883D8")]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    public interface ISimpleAudioVolume
    {
        int SetMasterVolume(
            float fLevel,
            IntPtr EventContext);

        int GetMasterVolume(
            out float pfLevel);

        int SetMute(
            [MarshalAs(UnmanagedType.Bool)] bool bMute,
            IntPtr EventContext);

        int GetMute(
            [MarshalAs(UnmanagedType.Bool)] out bool pbMute);
    }

    public static class AudioController
    {
        private static readonly PROPERTYKEY PKEY_Device_FriendlyName =
            new PROPERTYKEY
            {
                fmtid = new Guid(
                    "A45C254E-DF1C-4EFD-8020-67D146A850E0"),
                pid = 14
            };

        public static string[] MuteDiscord(
            string deviceNamePart,
            string processName)
        {
            List<string> messages = new List<string>();

            IMMDeviceEnumerator enumerator =
                (IMMDeviceEnumerator)new MMDeviceEnumerator();

            IMMDeviceCollection collection;

            // =================================================
            // CRITICAL :
            // RENDER est la cible VALIDEE pour ton sndvol.
            // NE PAS remplacer par eCapture.
            // =================================================

            int hr = enumerator.EnumAudioEndpoints(
                EDataFlow.eRender,
                DEVICE_STATE.ACTIVE,
                out collection);

            Marshal.ThrowExceptionForHR(hr);

            uint deviceCount;

            hr = collection.GetCount(out deviceCount);
            Marshal.ThrowExceptionForHR(hr);

            bool deviceFound = false;
            bool sessionFound = false;

            for (uint i = 0; i < deviceCount; i++)
            {
                IMMDevice device;

                hr = collection.Item(i, out device);

                if (hr != 0)
                    continue;

                IPropertyStore properties;

                hr = device.OpenPropertyStore(
                    0,
                    out properties);

                if (hr != 0)
                    continue;

                PROPVARIANT value;
                PROPERTYKEY key = PKEY_Device_FriendlyName;

                hr = properties.GetValue(
                    ref key,
                    out value);

                if (hr != 0)
                    continue;

                string friendlyName = value.GetString();

                if (String.IsNullOrEmpty(friendlyName))
                    continue;

                if (friendlyName.IndexOf(
                    deviceNamePart,
                    StringComparison.OrdinalIgnoreCase) < 0)
                {
                    continue;
                }

                deviceFound = true;

                messages.Add(
                    "[OK] Peripherique trouve : " +
                    friendlyName);

                Guid sessionManagerIID =
                    new Guid(
                        "77AA99A0-1BD6-484F-8BC7-2C654C9A9B6F");

                object managerObject;

                hr = device.Activate(
                    ref sessionManagerIID,
                    23,
                    IntPtr.Zero,
                    out managerObject);

                if (hr != 0)
                    continue;

                IAudioSessionManager2 manager =
                    (IAudioSessionManager2)managerObject;

                IAudioSessionEnumerator sessionEnumerator;

                hr = manager.GetSessionEnumerator(
                    out sessionEnumerator);

                if (hr != 0)
                    continue;

                int sessionCount;

                hr = sessionEnumerator.GetCount(
                    out sessionCount);

                if (hr != 0)
                    continue;

                messages.Add(
                    "[INFO] Sessions audio trouvees : " +
                    sessionCount);

                for (int s = 0; s < sessionCount; s++)
                {
                    IAudioSessionControl control;

                    hr = sessionEnumerator.GetSession(
                        s,
                        out control);

                    if (hr != 0)
                        continue;

                    IAudioSessionControl2 control2;

                    try
                    {
                        control2 =
                            (IAudioSessionControl2)control;
                    }
                    catch
                    {
                        continue;
                    }

                    uint pid;

                    hr = control2.GetProcessId(out pid);

                    if (hr != 0 || pid == 0)
                        continue;

                    try
                    {
                        Process process =
                            Process.GetProcessById((int)pid);

                        if (!process.ProcessName.Equals(
                            processName,
                            StringComparison.OrdinalIgnoreCase))
                        {
                            continue;
                        }

                        sessionFound = true;

                        messages.Add(
                            "[OK] Session Discord trouvee - PID " +
                            pid);

                        Guid iidSimpleAudioVolume =
                            new Guid(
                                "87CE5498-68D6-44E5-9215-6DA47EF883D8");

                        IntPtr unknownPointer =
                            Marshal.GetIUnknownForObject(control);

                        IntPtr volumePointer =
                            IntPtr.Zero;

                        try
                        {
                            hr = Marshal.QueryInterface(
                                unknownPointer,
                                ref iidSimpleAudioVolume,
                                out volumePointer);

                            Marshal.ThrowExceptionForHR(hr);

                            if (volumePointer == IntPtr.Zero)
                                continue;

                            ISimpleAudioVolume volume =
                                (ISimpleAudioVolume)
                                Marshal.GetObjectForIUnknown(
                                    volumePointer);

                            bool before;

                            hr = volume.GetMute(out before);
                            Marshal.ThrowExceptionForHR(hr);

                            messages.Add(
                                "[INFO] Mute avant = " +
                                before);

                            // =================================
                            // MUTE
                            // =================================

                            if (!before)
                            {
                                hr = volume.SetMute(
                                    true,
                                    IntPtr.Zero);

                                Marshal.ThrowExceptionForHR(hr);
                            }

                            bool after;

                            hr = volume.GetMute(out after);
                            Marshal.ThrowExceptionForHR(hr);

                            messages.Add(
                                "[OK] Discord.exe PID " +
                                pid +
                                " : " +
                                before +
                                " -> " +
                                after);
                        }
                        finally
                        {
                            if (volumePointer != IntPtr.Zero)
                                Marshal.Release(volumePointer);

                            if (unknownPointer != IntPtr.Zero)
                                Marshal.Release(unknownPointer);
                        }
                    }
                    catch (ArgumentException)
                    {
                        // Le processus a disparu entre-temps.
                    }
                    catch (InvalidOperationException)
                    {
                    }
                }
            }

            if (!deviceFound)
            {
                messages.Add(
                    "[ERREUR] SteelSeries Sonar - Microphone introuvable.");
            }
            else if (!sessionFound)
            {
                messages.Add(
                    "[ATTENTE] Aucune session Discord trouvee.");
            }

            return messages.ToArray();
        }
    }
}
'@


# ============================================================
# WATCHER
# ============================================================
#
# Principe :
#
# Discord ferme
#     -> simple Get-Process toutes les 5 secondes
#
# Discord ouvert
#     -> verification de la session audio toutes les 5 secondes
#
# Si Discord recree sa session :
#     -> elle sera mutee au prochain passage
#
# Aucun changement n'est effectue sur eCapture.
# ============================================================

while ($true)
{
    $discordRunning =
        Get-Process `
            -Name $TargetProcess `
            -ErrorAction SilentlyContinue

    if ($discordRunning)
    {
        try
        {
            [CoreAudio.AudioController]::MuteDiscord(
                $TargetDevice,
                $TargetProcess
            ) | Out-Null
        }
        catch
        {
            # Discord/Sonar peut recreer une session pendant
            # exactement notre verification.
            #
            # On ne fait rien et on reessaie 5 secondes
            # plus tard.
        }
    }

    Start-Sleep -Seconds $CheckInterval
}