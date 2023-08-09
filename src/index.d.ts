/**
 * Providers screenGuis with a given display order for easy use.
 *
 * @example
 * ```ts
 * export = new GenericScreenGuiProvider({
 * 	CLOCK: 5, // Register layers here
 * 	BLAH: 8,
 * 	CHAT: 10,
 * });
 * ```
 *
 * In a script that needs a new ScreenGui, do this:
 *
 * ```ts
 * // Load your game's provider (see above for registration)
 * import screenGuiProvider from "path/to/provider";
 *
 * //  Yay, now you have a new screen gui
 * const screenGui = screenGuiProvider.Get("CLOCK");
 * gui.Parent = screenGui;
 * ```
 */
declare class GenericScreenGuiProvider<LayoutOrders extends Record<string, number>> {
	/**
	 * The default AutoLocalize property for all screen guis.
	 * @default false
	 */
	public DefaultAutoLocalize: boolean;

	/**
	 * Constructs a new screen gui provider.
	 * @param layoutOrders
	 */
	public constructor(layoutOrders: LayoutOrders);

	/**
	 * Gets a screen gui by its order name.
	 * @param orderName The name of the order.
	 */
	public Get<OrderName extends keyof LayoutOrders>(orderName: OrderName): ScreenGui;
	public Get<OrderName extends keyof LayoutOrders>(orderName: OrderName): Frame;

	/**
	 * Retrieve the display order for a given order.
	 * @param orderName Order name of display order
	 */
	public GetDisplayOrder<OrderName extends keyof LayoutOrders>(orderName: OrderName): LayoutOrders[OrderName];

	/**
	 * Sets up a mock parent for the given target during test mode.
	 * @param target Technically a GuiBase, but who cares.
	 * @return Cleanup function to reset mock parent
	 */
	public SetupMockParent(target: Instance): () => void;
}

export = GenericScreenGuiProvider;
